// Dart imports:
import 'dart:async';
import 'dart:io';
import 'dart:convert';

// Package imports:
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_launcher/cli_launcher.dart';
import 'package:cli_util/cli_logging.dart';

// Project imports:
import './version.g.dart';
import 'command/commands.dart';  // ✅ Import all command modules
import 'logger.dart';
import 'session_manager.dart';

import 'command/bsky_command.dart';

/// Helper function to determine session file path dynamically
String getSessionFilePath(String account) {
  final homeDir = Platform.environment['HOME'];
  return account == 'main'
      ? '$homeDir/.bsky_session_main.json'
      : '$homeDir/.bsky_session_live.json';
}

/// A class that can run Bsky commands.
class BskyCommandRunner extends CommandRunner<void> {
  BskyCommandRunner()
      : super(
          'bsky',
          "A useful and powerful CLI tool to use Bluesky Social's APIs.",
        ) {
    _addGlobalOptions();
    _registerCommands();  // ✅ Register all Bluesky commands
  }

  void _addGlobalOptions() {
    argParser
      ..addOption(
        'identifier',
        help: 'Handle or email address for authentication.',
        defaultsTo: Platform.environment['BLUESKY_IDENTIFIER'],
      )
      ..addFlag(
       'debug',
        negatable: false,
        help: 'Enable detailed debug output.',
      )
      ..addFlag(
        'version',
        negatable: false,
        help: 'Display the current version of the bsky CLI tool.',
      )
      ..addOption(
        'account',
        help: 'Choose which account to use (live or main)',
        allowed: ['live', 'main'],
        defaultsTo: 'live',
      )
      ..addFlag(
        'show-session',
        negatable: false,
        help: 'Display the current session file contents.',
      )
      ..addOption(
        'password',
        help: 'Bluesky password for authentication.',
        defaultsTo: Platform.environment['BLUESKY_PASSWORD'],
      )
      ..addOption(
        'service',
        help: 'Name of the service sending the request. Defaults to "bsky.social".',
        defaultsTo: null,
      )
      ..addFlag(
        'pretty',
        negatable: false,
        help: 'Enable to output JSON in pretty format.',
      )
      ..addFlag(
        'status',
        negatable: false,
        help: 'Enable to output status code and reason phrase.',
      )
      ..addFlag(
        'request',
        negatable: false,
        help: 'Enable to output request method and URI.',
      )
      ..addFlag(
        'verbose',
        negatable: false,
        help: 'Enable verbose logging.',
      );
  }

  /// ✅ Register Bluesky Commands
  void _registerCommands() {
    for (final command in [
      ...commonCommands,
      ...actorCommands,
      ...feedCommands,
      ...notificationCommands,
      ...graphCommands,
      ...unspeccedCommands,
    ]) {
      addCommand(command);
    }
  }

  @override
  Future<void> runCommand(ArgResults topLevelResults) async {
    final logger = BskyLogger(Logger.standard());

    // Set the session file based on the account
    final account = topLevelResults['account'] as String? ?? 'live';
    SessionManager.setSessionFilePath(account);

    // Set environment variables indirectly by creating local variables
    final identifier = account == 'main'
        ? Platform.environment['BLUESKY_MAIN_IDENTIFIER'] ?? ''
        : Platform.environment['BLUESKY_LIVE_IDENTIFIER'] ?? '';

    final password = account == 'main'
        ? Platform.environment['BLUESKY_MAIN_PASSWORD'] ?? ''
        : Platform.environment['BLUESKY_LIVE_PASSWORD'] ?? '';

    // Pass these credentials dynamically to authentication (inside BskyCommand)
    BskyCommand.customIdentifier = identifier;
    BskyCommand.customPassword = password;

    // Handle --version
    if (topLevelResults['version'] == true) {
      logger.log('$version-rsn.6 (RSNStats fork)');
      return;
    }

    // Handle --show-session
    if (topLevelResults['show-session'] == true) {
      if (File(SessionManager.sessionFilePath).existsSync()) {
        final sessionData =
            jsonDecode(File(SessionManager.sessionFilePath).readAsStringSync());
        print(JsonEncoder.withIndent('  ').convert(sessionData)); // Pretty-print JSON
      } else {
        print(
            '⚠️ No active session found for $account at ${SessionManager.sessionFilePath}');
      }
      exit(0);
    }

    // Run the actual command
    await super.runCommand(topLevelResults);
  }
}

/// Entry point for executing commands
FutureOr<void> entryPoint(
  List<String> args, [
  LaunchContext? context, // ✅ Correct placement of brackets
]) async {
  final runner = BskyCommandRunner();

  try {
    await runner.run(args);
  } on UsageException catch (e) {
    stderr.writeln(e.toString());
    exitCode = 1;
  } catch (err) {
    exitCode = 1;
    rethrow;
  }
}
