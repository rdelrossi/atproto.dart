import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:xrpc/xrpc.dart' as xrpc;
import 'package:intl/intl.dart';

import '../authentication.dart';
import '../logger.dart';
import '../session_manager.dart';

bool _sessionRefreshed = false; // Prevent double-refreshing in a single command

abstract class BskyCommand extends Command<void> {
  /// Returns the new instance of [BskyCommand].
  BskyCommand();

  static String customIdentifier = '';
  static String customPassword = '';

  /// The logger
  late final logger = BskyLogger(globalResults!['verbose']! as bool
      ? Logger.verbose()
      : Logger.standard());

  late final service = globalResults!['service'] as String?;
  
  // Add debug flag shortcut for cleaner code
  bool get isDebugMode => globalResults?['debug'] as bool? ?? false;

  /// The authentication.
  late final _auth = Authentication(
    customIdentifier.isNotEmpty ? customIdentifier : globalResults!['identifier'],
    customPassword.isNotEmpty ? customPassword : globalResults!['password'],
  );

  Map<String, dynamic> _session = {};
  bool _sessionLoaded = false; // Track if session has been loaded already
  bool _sessionValidated = false; // Track if session has been validated already

  String _decodeJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT token format.');
    }
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    return payload;
  }

  DateTime? _getTokenExpiration(String jwt) {
    try {
      final segments = jwt.split('.');
      if (segments.length != 3) return null;

      final payload = base64Url.decode(base64Url.normalize(segments[1]));
      final payloadMap = jsonDecode(utf8.decode(payload)) as Map<String, dynamic>;

      final exp = payloadMap['exp'] as int?;
      if (exp == null) return null;

      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    } catch (e) {
      logger.error('Error decoding JWT: $e');
      return null;
    }
  }

  bool _isTokenExpired(String jwt) {
    try {
        final segments = jwt.split('.');
        if (segments.length != 3) return true; // Invalid JWT

        final payload = base64Url.decode(base64Url.normalize(segments[1]));
        final payloadMap = jsonDecode(utf8.decode(payload)) as Map<String, dynamic>;

        final exp = payloadMap['exp'] as int?;
        if (exp == null) return true;

        final expiration = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        return DateTime.now().isAfter(expiration);
      } catch(e) {
        logger.error('Error decoding JWT: $e');
        return true; // Assume expired if we can't parse it
      }
  }

  void _saveSession() {
    try {
      final file = File(SessionManager.sessionFilePath);
      file.writeAsStringSync(jsonEncode(_session));
      if (isDebugMode) {
        logger.info('✅ Session saved to ${SessionManager.sessionFilePath}');
      }
    } catch (e) {
      logger.error('❌ Failed to save session: $e');
    }
  }

  void _loadSession() {
    // Skip if already loaded during this command execution
    if (_sessionLoaded) return;
    
    try {
      final sessionFile = File(SessionManager.sessionFilePath);
      if (sessionFile.existsSync()) {
        _session = jsonDecode(sessionFile.readAsStringSync());
        logger.info('Loaded session from ${SessionManager.sessionFilePath}');
        _sessionLoaded = true;
      } else {
        if (isDebugMode) {
          logger.info('No existing session found. A new session will be created.');
        }
      }
    } catch (e) {
      logger.error('Failed to load session: $e');
    }
  }

  Future<void> refreshSessionIfNeeded() async {
    // Skip if already validated or refreshed
    if (_sessionValidated || _sessionRefreshed) return;
    
    _sessionValidated = true; // Mark as validated to prevent duplicate checks
    
    if (_session.isNotEmpty && _isTokenExpired(_session['accessJwt'])) {
      logger.info('🔄 Expired session detected. Refreshing...');
      _session = await _refreshSession(_session['refreshJwt']);
      _saveSession();
      _sessionRefreshed = true;
    } else if (isDebugMode) {
      // Only log in debug mode to avoid duplicate messages
      logger.info('✅ Session is valid');
    }
  }

  /// Returns the authenticated access token.
  Future<String> get accessJwt async {
    _loadSession();  // Load the session before checking for expiration

    if (_session.isEmpty) {
      // If no session exists, create a new one
      final session = await _createSession();
      return session['accessJwt'];
    }

    // Refresh session only if necessary
    await refreshSessionIfNeeded();
    return _session['accessJwt'];
  }

  /// Returns the authenticated DID.
  Future<String> get did async {
    if (_session.isNotEmpty) {
      return _session['did'];
    }

    final session = await _createSession();

    return session['did'];
  }

  Future<Map<String, dynamic>> _refreshSession(String refreshToken) async {
    if (isDebugMode) {
      logger.info('Attempting to refresh session...');
    }

    final response = await xrpc.procedure<String>(
      xrpc.NSID.create('server.atproto.com', 'refreshSession'),
      service: service,
      headers: {
        'Authorization': 'Bearer $refreshToken',
      },
    );

    if (isDebugMode) {
      logger.info('Raw response: ${response.data}'); // Debugging output
    }

    try {
      // Ensure response is valid
      final refreshedSession = jsonDecode(response.data);

      if (refreshedSession.containsKey('accessJwt') && refreshedSession.containsKey('refreshJwt')) {
        _session = refreshedSession;
        _saveSession();  // Save updated session with new JWTs
        logger.info('Session refreshed successfully.');
        return refreshedSession;
      } else {
        throw Exception('Missing required fields in session response.');
      }
    } catch (e) {
      logger.error('Failed to parse session refresh response: $e');
      throw Exception('Session refresh response parsing failed');
    }
  }

  Future<Map<String, dynamic>> _createSession() async {
    final sessionFile = File(SessionManager.sessionFilePath);

    if (sessionFile.existsSync()) {
      try {
        final existingSession = jsonDecode(sessionFile.readAsStringSync());

        if (!_isTokenExpired(existingSession['accessJwt'])) {
          final expiryTime = _getTokenExpiration(existingSession['accessJwt']);
          final formattedExpiryTime = expiryTime != null
              ? DateFormat('yyyy-MM-dd HH:mm:ss').format(expiryTime)
              : 'Unknown';

          logger.info(
              'Reusing existing session from ${SessionManager.sessionFilePath}. Expires: $formattedExpiryTime');
          _session = existingSession;
          return _session;
        } else {
          logger.info('Session expired. Attempting to refresh...');
          final refreshedSession =
              await _refreshSession(existingSession['refreshJwt']);
          _session = refreshedSession;
          _saveSession();
          return refreshedSession;
        }
      } catch (e) {
        logger.error('Failed to read or parse existing session: $e');
      }
    }

    // No session found, creating a new one
    logger.info('No valid session found. Creating a new session...');

    final response = await xrpc.procedure<String>(
      xrpc.NSID.create('server.atproto.com', 'createSession'),
      service: service,
      body: {
        'identifier': _auth.identifier,
        'password': _auth.password,
      },
    );

    logger.info('Session creation response status: ${response.status}');
    
    // Try using the string representation instead
    if (response.status.toString() == 'HttpStatus.ok') {
      try {
        final newSession = jsonDecode(response.data);

        if (!newSession.containsKey('accessJwt') || !newSession.containsKey('refreshJwt')) {
          logger.error('❌ Missing accessJwt or refreshJwt in session response.');
          throw Exception('Invalid session response.');
        }

        // Decode the JWT to get expiration
        final jwt = newSession['accessJwt'];
        final parts = jwt.split('.');
        if (parts.length != 3) {
          throw Exception('Invalid JWT format');
        }

        // Decode the payload (middle part of JWT)
        final payload = json.decode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))
        );
        
        // Convert exp timestamp to DateTime
        final expiration = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);

        _session = newSession;
        _saveSession();
        logger.info('✅ New session created and saved successfully. Expires: ${expiration.toLocal()}');
        return _session;

      } catch (e) {
        logger.error('❌ Failed to parse session response: $e');
        throw Exception('Session response parsing failed');
      }
    } else {
      logger.error('❌ Unexpected response status: ${response.status}');
      throw Exception('Session creation failed');
    }
  }
    
  Future<xrpc.XRPCResponse<String>> upload(
    final File file,
  ) async =>
      await xrpc.procedure<String>(
        xrpc.NSID.create(
          'repo.atproto.com',
          'uploadBlob',
        ),
        body: file.readAsBytesSync(),
        headers: {
          'Authorization': 'Bearer ${await accessJwt}',
        },
      );
}
