// Copyright 2023 Shinya Kato. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

final _atUriRegex = RegExp(
  // ignore: lines_longer_than_80_chars
  // proto-    --did--------------   --name-------------   --path----   --query--   --hash--
  r'^(at:\/\/)?((?:did:[a-z0-9:%-]+)|(?:[a-z][a-z0-9.:-]*))(\/[^?#\s]*)?(\?[^#\s]+)?(#[^\s]+)?$',
  caseSensitive: false,
);

/// This is the Dart implementation of AT Uri in AT Protocol.
///
/// ## Grammar
///
/// - atp-url   = "at://" authority path [ "#" fragment ]
/// - authority = reg-name / did
/// - path      = [ "/" coll-nsid [ "/" record-id ] ]
/// - coll-nsid = nsid
/// - record-id = 1*pchar
sealed class AtUri {
  /// Returns the new instance of unparsed AT URI.
  const factory AtUri(final String uri) = UnparsedAtUri;

  /// Returns the new instance of parsed AT URI.
  factory AtUri.parse(final String uri) = ParsedAtUri;

  /// Returns the new instance of parsed AT URI based on [handleOrDid],
  /// and [collection] and [rkey] as optionals.
  factory AtUri.make(
    final String handleOrDid, [
    final String? collection,
    final String? rkey,
  ]) {
    final buffer = StringBuffer(handleOrDid);
    if (collection != null) buffer.write('/$collection');
    if (rkey != null) buffer.write('/$rkey');

    return ParsedAtUri(buffer.toString());
  }

  /// Returns the protocol.
  String get protocol;

  /// Returns the origin.
  String get origin;

  /// Returns the pathname.
  String get pathname;

  /// Returns the hostname.
  String get hostname;

  /// Returns the collection.
  String get collection;

  /// Returns the rkey.
  String get rkey;

  /// Returns the hash.
  String get hash;

  /// Returns the href.
  String get href;
}

final class ParsedAtUri implements AtUri {
  ParsedAtUri(final String uri) {
    final parsed = _parse(uri);
    if (parsed == null) throw FormatException('Invalid at uri: $uri');

    hash = parsed['hash'] ?? '';
    _host = parsed['host'] ?? '';
    pathname = parsed['pathname'] ?? '';
  }

  Map<String, dynamic>? _parse(final String uri) {
    final match = _atUriRegex.firstMatch(uri);
    return match == null
        ? null
        : {
            'host': match.group(2) ?? '',
            'pathname': match.group(3) ?? '',
            'hash': match.group(5) ?? '',
          };
  }

  late String _host;

  @override
  String get protocol => 'at:';

  @override
  String get origin => 'at://$_host';

  @override
  late String pathname;

  @override
  String get hostname => _host;

  @override
  String get collection =>
      (pathname.split('/')..removeWhere((s) => s.isEmpty)).first;

  @override
  String get rkey =>
      (pathname.split('/')..removeWhere((s) => s.isEmpty)).elementAt(1);

  @override
  late String hash;

  @override
  String get href => toString();

  @override
  String toString() {
    final buffer = StringBuffer('at://')..write(_host);

    if (!pathname.startsWith('/')) {
      buffer.write('/$pathname');
    } else {
      buffer.write(pathname);
    }

    if (hash.isNotEmpty && !hash.startsWith('#')) {
      buffer.write('#$hash');
    } else {
      buffer.write(hash);
    }

    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is AtUri) return other.toString() == toString();
    return false;
  }

  @override
  int get hashCode => toString().hashCode;
}

final class UnparsedAtUri implements AtUri {
  const UnparsedAtUri(this._uri);

  /// Not parsed uri.
  final String _uri;

  @override
  String get protocol => 'at:';

  @override
  String get origin => 'at://$hostname';

  @override
  String get pathname {
    final match = _atUriRegex.firstMatch(_uri);
    if (match == null) throw FormatException('Invalid at uri: $_uri');

    return match.group(3) ?? '';
  }

  @override
  String get hostname {
    final match = _atUriRegex.firstMatch(_uri);
    if (match == null) throw FormatException('Invalid at uri: $_uri');

    return match.group(2) ?? '';
  }

  @override
  String get collection =>
      (pathname.split('/')..removeWhere((s) => s.isEmpty)).first;

  @override
  String get rkey =>
      (pathname.split('/')..removeWhere((s) => s.isEmpty)).elementAt(1);

  @override
  String get hash {
    final match = _atUriRegex.firstMatch(_uri);
    if (match == null) throw FormatException('Invalid at uri: $_uri');

    return match.group(5) ?? '';
  }

  @override
  String get href => toString();

  @override
  String toString() => _uri;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is AtUri) return other.toString() == toString();
    return false;
  }

  @override
  int get hashCode => toString().hashCode;
}
