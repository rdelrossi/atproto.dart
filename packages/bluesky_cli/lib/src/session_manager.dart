import 'dart:io';
import 'dart:convert';

class SessionManager {
  static String _sessionFilePath = '';

  static void setSessionFilePath(String account) {
    final homeDir = Platform.environment['HOME'];
    _sessionFilePath = account == 'main'
        ? '$homeDir/.bsky_session_main.json'
        : '$homeDir/.bsky_session_live.json';
  }

  /// Returns the current session file path
  static String get sessionFilePath => _sessionFilePath;

  /// Returns session expiration time or "Unknown" if unavailable
  static String getSessionExpiration() {
    if (!File(_sessionFilePath).existsSync()) return 'Unknown';

    try {
      final sessionData = jsonDecode(File(_sessionFilePath).readAsStringSync());
      final accessJwt = sessionData['accessJwt'] as String?;
      return extractExpirationFromJwt(accessJwt);
    } catch (e) {
      return 'Error retrieving session expiration';
    }
  }

  /// Extracts expiration timestamp from accessJwt
  static String extractExpirationFromJwt(String? jwt) {
    if (jwt == null) return 'Unknown';
    try {
      final parts = jwt.split('.');
      if (parts.length != 3) return 'Invalid JWT';

      return decodeJwtExpiration(parts[1]);
    } catch (e) {
      return 'Error decoding JWT';
    }
  }

  /// Decodes JWT payload to extract expiration timestamp
  static String decodeJwtExpiration(String jwtPayload) {
    try {
      // Decode JWT payload (Base64)
      final payloadJson = utf8.decode(base64Url.decode(base64Url.normalize(jwtPayload)));
      final payload = jsonDecode(payloadJson);

      // Extract expiration timestamp
      final int? expTimestamp = payload['exp'];
      if (expTimestamp == null) return 'Unknown';

      // Convert to human-readable local time
      final expirationDate = DateTime.fromMillisecondsSinceEpoch(expTimestamp * 1000, isUtc: true);
      return expirationDate.toLocal().toString();
    } catch (e) {
      return 'Error decoding JWT';
    }
  }
}