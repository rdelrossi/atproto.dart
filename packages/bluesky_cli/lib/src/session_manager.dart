import 'dart:io';

class SessionManager {
  static String _sessionFilePath = '';

  static void setSessionFilePath(String account) {
    final homeDir = Platform.environment['HOME'];
    _sessionFilePath = account == 'main'
        ? '$homeDir/.bsky_session_main.json'
        : '$homeDir/.bsky_session_live.json';
  }

  static String get sessionFilePath => _sessionFilePath;
}