// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:at_uri/at_uri.dart';
import 'package:bluesky_text/bluesky_text.dart';
import 'package:xrpc/xrpc.dart' as xrpc;

// Project imports:
import '../create_record_command.dart';

// For fetchMetadata():
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

/// `app.bsky.feed.post`
class PostCommand extends CreateRecordCommand {
  /// Returns the new instance of [PostCommand].
  PostCommand() {
    argParser
      ..addOption(
        'text',
        help: 'Text to be posted to Bluesky Social.',
        defaultsTo: '',
      )
      ..addOption(
        'reply',
        help: 'AT URI of the post to which you are replying',
        defaultsTo: null,
      )
      ..addOption(
        'images',
        help:
            'Comma-separated collection of image paths to attach to the post.',
        defaultsTo: null,
      )
      ..addOption(
        'langs',
        help: 'A collection of well-formed BCP47 language tags in CSV format.',
        defaultsTo: null,
      )
      ..addOption(
        'labels',
        help: 'A collection of self labels in CSV format.',
        defaultsTo: null,
      )
      ..addOption(
        'tags',
        help: 'Additional non-inline tags describing this post.',
        defaultsTo: null,
      )
      ..addOption(
        'created-at',
        help: 'Date and time the post is created in ISO 8601 format.',
        defaultsTo: DateTime.now().toUtc().toIso8601String(),
      );
  }

  @override
  String get name => 'post';

  @override
  String get description => 'Post to Bluesky Social.';

  @override
  final String invocation =
      'bsky post [text] [reply] [images] [langs] [labels] [tags] [created-at]';

  @override
  xrpc.NSID get collection => xrpc.NSID.create(
        'feed.bsky.app',
        'post',
      );

  @override
  FutureOr<Map<String, dynamic>> get record async {
      await refreshSessionIfNeeded();  // 🔥 Ensure correct session

      final rawText = argResults!['text'];  // ✅ Keep unaltered text
      final parsedText = BlueskyText(rawText);  // ✅ Process text for entities

      final urlRegex = RegExp(r"https?://\S+");
      final match = urlRegex.firstMatch(rawText);
      String? extractedUrl = match?.group(0);

      final record = {
          'text': extractedUrl != null
              ? rawText.replaceAll(extractedUrl, "").trim()  // Remove URL from text
              : rawText,
          'facets': await parsedText.entities.toFacets(service: service),
          'createdAt': argResults!['created-at'],
      };

      final metadata = extractedUrl != null ? await fetchMetadata(extractedUrl) : {};  // ✅ Ensure metadata exists
      String? blobRef;

      if (extractedUrl != null && metadata.containsKey('image') && metadata['image']!.isNotEmpty) {
          final uploadResponse = await uploadImageToBluesky(metadata['image']!);

          if (uploadResponse != null && uploadResponse.containsKey('blob')) {
              // Now construct the record with the external embed using the ENTIRE blob object
              record['embed'] = {
                  r'$type': 'app.bsky.embed.external',
                  'external': {
                      'uri': extractedUrl,
                      'title': metadata['title'] ?? 'Untitled',
                      'description': metadata['description'] ?? '',
                      'thumb': uploadResponse['blob']  // Use the complete blob object as returned by the API
                  },
              };
          } else {
              // Fallback without the thumbnail
              record['embed'] = {
                  r'$type': 'app.bsky.embed.external',
                  'external': {
                      'uri': extractedUrl,
                      'title': metadata['title'] ?? 'Untitled',
                      'description': metadata['description'] ?? '',
                  },
              };
          }
      } else if (extractedUrl != null) {
          // Link without image metadata
          record['embed'] = {
              r'$type': 'app.bsky.embed.external',
              'external': {
                  'uri': extractedUrl,
                  'title': metadata['title'] ?? 'Untitled',
                  'description': metadata['description'] ?? '',
              },
          };
      }      
      
      if (argResults!['reply'] != null) {
          final post = await _getPost(AtUri.parse(argResults!['reply']));

          record['reply'] = {
              'root': {
                  'uri': post['uri'],
                  'cid': post['cid'],
              },
              'parent': {
                  'uri': post['uri'],
                  'cid': post['cid'],
              },
          };
      }

      final images = await _uploadImages();
      if (images.isNotEmpty) {
          record['embed'] = {
              r'$type': 'app.bsky.embed.images',
              'images': images,
          };
      } else {
          if (rawText.isEmpty) {  // ✅ Use `rawText`, since `text` is removed
              throw ArgumentError(
                  'text must not be empty when embed is null.',
              );
          }
      }

      final langs = _langs;
      if (langs != null) {
          record['langs'] = langs;
      }

      final labels = _labels;
      if (labels != null) {
          record['labels'] = labels;
      }

      final tags = _tags;
      if (tags != null) {
          record['tags'] = tags;
      }

      print('🛠️ DEBUG: Final record structure -> ${jsonEncode(record)}');

      return record;
  }

  List<String>? get _langs {
    if (argResults!['langs'] == null) {
      return null;
    }

    final langs = argResults!['langs'];

    return langs.split(',');
  }

  List<String>? get _tags {
    if (argResults!['tags'] == null) {
      return null;
    }

    final tags = argResults!['tags'];

    return tags.split(',');
  }

  Map<String, dynamic>? get _labels {
    if (argResults!['labels'] == null) {
      return null;
    }

    final String labels = argResults!['labels'];

    return {
      r'$type': 'com.atproto.label.defs#selfLabels',
      'values': labels
          .split(',')
          .map(
            (e) => {
              r'$type': 'com.atproto.label.defs#selfLabel',
              'val': e,
            },
          )
          .toList(),
    };
  }

  Future<Map<String, String>> fetchMetadata(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return {};

      final document = parse(response.body);
      String? getMeta(String property) {
        return document
            .head!
            .querySelector('meta[property="$property"]')
            ?.attributes['content'];
      }

      return {
        'title': getMeta('og:title') ?? 'Untitled',
        'description': getMeta('og:description') ?? 'No description available.',
        'image': getMeta('og:image') ?? '',
      };
    } catch (e) {
      print("Error fetching metadata: $e");
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> _uploadImages() async {
    if (argResults!['images'] == null) {
      return const [];
    }

    await refreshSessionIfNeeded();  // Ensure the right session is active

    final images = <Map<String, dynamic>>[];
    for (final image in argResults!['images'].split(',')) {
      final uploaded = await upload(File(image));

      final blob = jsonDecode(uploaded.data);

      images.add({
        'alt': '',
        'image': blob['blob'],
      });
    }

    return images;
  }

  Future<Map<String, dynamic>?> uploadImageToBluesky(String imageUrl) async {
      print('🛠️ DEBUG: Downloading image from URL -> $imageUrl');

      try {
          // Fetch the image
          final response = await http.get(Uri.parse(imageUrl));
          if (response.statusCode != 200) {
              print('❌ Failed to download image: ${response.statusCode}');
              return null;
          }

          // Save image temporarily
          final tempDir = Directory.systemTemp;
          final tempFile = File('${tempDir.path}/bluesky_upload.jpg');
          await tempFile.writeAsBytes(response.bodyBytes);

          print('🛠️ DEBUG: Uploading image from local file -> ${tempFile.path}');

          // Upload using Bluesky API
          final uploaded = await upload(tempFile);
          
          print('🛠️ DEBUG: Upload Response -> ${uploaded.data}');
          
          // Return the complete response
          return jsonDecode(uploaded.data);
      } catch (e) {
          print('❌ Upload Error: $e');
          return null;
      }
  }

  Future<Map<String, dynamic>> _getPost(
    final AtUri uri,
  ) async {
    await refreshSessionIfNeeded();  // Ensure correct session

    final response = await xrpc.query<Map<String, dynamic>>(
      xrpc.NSID.create(
        'feed.bsky.app',
        'getPosts',
      ),
      parameters: {
        'uris': [uri],
      },
      headers: {
        'Authorization': 'Bearer ${await accessJwt}',
      },
    );

    return response.data['posts'].first;
  }
}

