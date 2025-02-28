// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:io';
// Package imports:
import 'package:cli_util/cli_logging.dart';
import 'package:xrpc/xrpc.dart';
// Project imports:
import '../logger.dart';

class Bsky extends _Bsky {
  Bsky(
    Logger? logger, {
    required this.action,
    required this.pretty,
    required this.showStatus,
    required this.showRequest,
    this.debug = false,
  }) : logger = (logger ?? Logger.standard()).toBskyLogger();

  @override
  final BskyLogger logger;

  /// The bsky action.
  final Future<XRPCResponse<String>> Function() action;

  /// The flag indicates whether JSON should be formatted for output.
  final bool pretty;

  /// The flag indicates whether status code and reason phrase should be output.
  final bool showStatus;

  /// The flag indicates whether request method and request URI should be output
  final bool showRequest;
  
  /// The flag indicates whether to output detailed debug information
  final bool debug;

  @override
  Future<void> run() async {
    try {
      final response = await action.call();
      final status = response.status;
      
      if (showStatus) {
        logger.success('${status.code} ${status.message}');
      }
      
      if (showRequest) {
        logger.success(response.request.toString());
      }
      
      // Only output JSON response when in debug mode or pretty format is requested
      final showOutput = debug || pretty;
      
      if (showOutput) {
        logger.success(_getJsonString(response.data));
      } else {
        // Check if this is a successful operation response
        try {
          final responseData = jsonDecode(response.data);
          // For createRecord operations, the response typically contains 'uri' and 'cid'
          if (responseData is Map && 
              responseData.containsKey('uri') && 
              responseData.containsKey('cid')) {
            final atUri = responseData['uri'] as String;
            // Convert AT URI to a web URL
            final webUrl = _convertAtUriToWebUrl(atUri);
            logger.info('✅ Bluesky post successful! View at: $webUrl');
          }
        } catch (e) {
          // If we can't parse the response, just don't show any message
        }
      }
    } on XRPCException catch (e) {
      final status = e.response.status;
      
      if (showStatus) {
        logger.error('${status.code} ${status.message}');
      }
      
      if (showRequest) {
        logger.error(e.response.request.toString());
      }
      
      // Always show error messages, but format based on pretty flag
      logger.error(_getJsonString(jsonEncode(e.response.data.toJson())));
      exitCode = 1;
    } catch (e) {
      logger.error(e.toString());
      exitCode = 1;
    }
  }

  /// Converts an AT Protocol URI to a clickable web URL
  /// Format: at://did:plc:abc123/app.bsky.feed.post/xyz456
  /// Becomes: https://bsky.app/profile/did:plc:abc123/post/xyz456
  String _convertAtUriToWebUrl(String atUri) {
    try {
      // Extract the DID and post ID from the AT URI
      final regex = RegExp(r'at://([^/]+)/[^/]+/(.+)');
      final match = regex.firstMatch(atUri);
      
      if (match != null && match.groupCount >= 2) {
        final did = match.group(1);
        final postId = match.group(2);
        return 'https://bsky.app/profile/$did/post/$postId';
      }
      
      // Fallback to the original URI if parsing fails
      return atUri;
    } catch (e) {
      return atUri;
    }
  }

  String _getJsonString(final String json) {
    if (pretty) {
      final encoder = JsonEncoder.withIndent('    ');
      return encoder.convert(jsonDecode(json));
    }
    return json;
  }
}

abstract class _Bsky {
  BskyLogger get logger;
  Future<void> run();
}