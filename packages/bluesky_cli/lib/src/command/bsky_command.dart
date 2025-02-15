// Dart imports:
import 'dart:convert';
import 'dart:io';
import 'dart:async';

// Package imports:
import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:xrpc/xrpc.dart' as xrpc;
import 'package:intl/intl.dart'; // Added to support displaying expiration date

// Project imports:
import '../authentication.dart';
import '../logger.dart';

final String sessionFilePath = '${Platform.environment['HOME']}/.bsky_session.json';

abstract class BskyCommand extends Command<void> {
  /// Returns the new instance of [BskyCommand].
  BskyCommand();

  /// The logger
  late final logger = BskyLogger(globalResults!['verbose']! as bool
      ? Logger.verbose()
      : Logger.standard());

  late final service = globalResults!['service'] as String?;

  /// The authentication.
  late final _auth = Authentication(
    globalResults!['identifier'],
    globalResults!['password'],
  );

  Map<String, dynamic> _session = {};

  String _decodeJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT token format.');
    }
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    return payload;
  }

  // DateTime _getTokenExpiration(String accessJwt) {
  //   try {
  //     final payloadJson = jsonDecode(_decodeJwt(accessJwt));
  //     final expTimestamp = payloadJson['exp']; // Unix timestamp
  //     return DateTime.fromMillisecondsSinceEpoch(expTimestamp * 1000);
  //   } catch (e) {
  //     throw Exception('Failed to parse token expiration: $e');
  //   }
  // }

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
      final file = File(sessionFilePath);
      file.writeAsStringSync(jsonEncode(_session));
      logger.info('Session saved to $sessionFilePath.');
    } catch (e) {
      logger.error('Failed to save session: $e');
    }
  }

  /// Returns the authenticated access token.
  Future<String> get accessJwt async {
    if (_session.isNotEmpty) {
      if (_isTokenExpired(_session['accessJwt'])) {
        logger.info('Access token expired, attempting to refresh session.');
        _session = await _refreshSession(_session['refreshJwt']);
      }
      return _session['accessJwt'];
    }

    // If no session exists, create a new one
    final session = await _createSession();
    return session['accessJwt'];
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
    logger.info('Attempting to refresh session...');

    final response = await xrpc.procedure<String>(
      xrpc.NSID.create('server.atproto.com', 'refreshSession'),
      service: service,
      headers: {
        'Authorization': 'Bearer $refreshToken',
      },
    );

    logger.info('Raw response: ${response.data}'); // Debugging output

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
    final sessionFile = File(sessionFilePath);

    // Check if a session file exists
    // if (sessionFile.existsSync()) {
    //   try {
    //     final existingSession = jsonDecode(sessionFile.readAsStringSync());

    //     if (!_isTokenExpired(existingSession['accessJwt'])) {
    //       final expiryTime = _getTokenExpiration(existingSession['accessJwt']);
    
    //       logger.info('Reusing existing session from $sessionFilePath.');
    //       _session = existingSession;
    //       return _session;
    //     } else {
    //       logger.info('Session expired. Attempting to refresh...');
    //       final refreshedSession = await _refreshSession(existingSession['refreshJwt']);
    //       _session = refreshedSession;
    //       _saveSession();
    //       return refreshedSession;
    //     }
    //   } catch (e) {
    //     logger.error('Failed to read or parse existing session: $e');
    //   }
    // }
  
    if (sessionFile.existsSync()) {
      try {
        final existingSession = jsonDecode(sessionFile.readAsStringSync());

        if (!_isTokenExpired(existingSession['accessJwt'])) {
          final expiryTime = _getTokenExpiration(existingSession['accessJwt']);
          final formattedExpiryTime = expiryTime != null
              ? DateFormat('yyyy-MM-dd HH:mm:ss').format(expiryTime)
              : 'Unknown';

          logger.info(
              'Reusing existing session from $sessionFilePath. Expires: $formattedExpiryTime');
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
