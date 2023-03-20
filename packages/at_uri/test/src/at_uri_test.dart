// Copyright 2023 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:at_uri/src/at_uri.dart';
import 'package:test/test.dart';

void main() {
  test('parses valid at uris', () {
    final cases = [
      [
        'foo.com',
        'foo.com',
        '',
        '',
        '',
      ],
      [
        'at://foo.com',
        'foo.com',
        '',
        '',
        '',
      ],
      [
        'at://foo.com/',
        'foo.com',
        '/',
        '',
        '',
      ],
      [
        'at://foo.com/foo',
        'foo.com',
        '/foo',
        '',
        '',
      ],
      [
        'at://foo.com/foo/',
        'foo.com',
        '/foo/',
        '',
        '',
      ],
      [
        'at://foo.com/foo/bar',
        'foo.com',
        '/foo/bar',
        '',
        '',
      ],
      [
        'at://foo.com?foo=bar',
        'foo.com',
        '',
        'foo=bar',
        '',
      ],
      [
        'at://foo.com?foo=bar&baz=buux',
        'foo.com',
        '',
        'foo=bar&baz=buux',
        '',
      ],
      [
        'at://foo.com/?foo=bar',
        'foo.com',
        '/',
        'foo=bar',
        '',
      ],
      [
        'at://foo.com/foo?foo=bar',
        'foo.com',
        '/foo',
        'foo=bar',
        '',
      ],
      [
        'at://foo.com/foo/?foo=bar',
        'foo.com',
        '/foo/',
        'foo=bar',
        '',
      ],
      [
        'at://foo.com#hash',
        'foo.com',
        '',
        '',
        '#hash',
      ],
      [
        'at://foo.com/#hash',
        'foo.com',
        '/',
        '',
        '#hash',
      ],
      [
        'at://foo.com/foo#hash',
        'foo.com',
        '/foo',
        '',
        '#hash',
      ],
      [
        'at://foo.com/foo/#hash',
        'foo.com',
        '/foo/',
        '',
        '#hash',
      ],
      [
        'at://foo.com?foo=bar#hash',
        'foo.com',
        '',
        'foo=bar',
        '#hash',
      ],
      [
        'did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        'did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        '',
        '',
        '',
      ],
      [
        'at://did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        'did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        '',
        '',
        '',
      ],
      [
        'at://did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw/',
        'did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        '/',
        '',
        '',
      ],
      [
        'at://did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw/foo',
        'did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        '/foo',
        '',
        '',
      ],
      [
        'at://did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw/foo/',
        'did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        '/foo/',
        '',
        '',
      ],
      [
        'at://did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw/foo/bar',
        'did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        '/foo/bar',
        '',
        '',
      ],
      [
        'at://did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw?foo=bar',
        'did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        '',
        'foo=bar',
        '',
      ],
      [
        'at://did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw?foo=bar&baz=buux',
        'did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        '',
        'foo=bar&baz=buux',
        '',
      ],
      [
        'at://did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw/?foo=bar',
        'did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        '/',
        'foo=bar',
        '',
      ],
      [
        'at://did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw/foo?foo=bar',
        'did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        '/foo',
        'foo=bar',
        '',
      ],
      [
        'at://did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw/foo/?foo=bar',
        'did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        '/foo/',
        'foo=bar',
        '',
      ],
      [
        'at://did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw#hash',
        'did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        '',
        '',
        '#hash',
      ],
      [
        'at://did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw/#hash',
        'did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        '/',
        '',
        '#hash',
      ],
      [
        'at://did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw/foo#hash',
        'did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        '/foo',
        '',
        '#hash',
      ],
      [
        'at://did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw/foo/#hash',
        'did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        '/foo/',
        '',
        '#hash',
      ],
      [
        'at://did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw?foo=bar#hash',
        'did:example:EiAnKD8-jfdd0MDcZUjAbRgaThBrMxPTFOxcnfJhI7Ukaw',
        '',
        'foo=bar',
        '#hash',
      ],
      [
        'did:web:localhost%3A1234',
        'did:web:localhost%3A1234',
        '',
        '',
        '',
      ],
      [
        'at://did:web:localhost%3A1234',
        'did:web:localhost%3A1234',
        '',
        '',
        '',
      ],
      [
        'at://did:web:localhost%3A1234/',
        'did:web:localhost%3A1234',
        '/',
        '',
        '',
      ],
      [
        'at://did:web:localhost%3A1234/foo',
        'did:web:localhost%3A1234',
        '/foo',
        '',
        '',
      ],
      [
        'at://did:web:localhost%3A1234/foo/',
        'did:web:localhost%3A1234',
        '/foo/',
        '',
        '',
      ],
      [
        'at://did:web:localhost%3A1234/foo/bar',
        'did:web:localhost%3A1234',
        '/foo/bar',
        '',
        '',
      ],
      [
        'at://did:web:localhost%3A1234?foo=bar',
        'did:web:localhost%3A1234',
        '',
        'foo=bar',
        '',
      ],
      [
        'at://did:web:localhost%3A1234?foo=bar&baz=buux',
        'did:web:localhost%3A1234',
        '',
        'foo=bar&baz=buux',
        '',
      ],
      [
        'at://did:web:localhost%3A1234/?foo=bar',
        'did:web:localhost%3A1234',
        '/',
        'foo=bar',
        '',
      ],
      [
        'at://did:web:localhost%3A1234/foo?foo=bar',
        'did:web:localhost%3A1234',
        '/foo',
        'foo=bar',
        '',
      ],
      [
        'at://did:web:localhost%3A1234/foo/?foo=bar',
        'did:web:localhost%3A1234',
        '/foo/',
        'foo=bar',
        '',
      ],
      [
        'at://did:web:localhost%3A1234#hash',
        'did:web:localhost%3A1234',
        '',
        '',
        '#hash',
      ],
      [
        'at://did:web:localhost%3A1234/#hash',
        'did:web:localhost%3A1234',
        '/',
        '',
        '#hash',
      ],
      [
        'at://did:web:localhost%3A1234/foo#hash',
        'did:web:localhost%3A1234',
        '/foo',
        '',
        '#hash',
      ],
      [
        'at://did:web:localhost%3A1234/foo/#hash',
        'did:web:localhost%3A1234',
        '/foo/',
        '',
        '#hash',
      ],
      [
        'at://did:web:localhost%3A1234?foo=bar#hash',
        'did:web:localhost%3A1234',
        '',
        'foo=bar',
        '#hash',
      ],
    ];

    for (final $case in cases) {
      final uri = AtUri.parse($case[0]);

      expect(uri.protocol, 'at:');
      expect(uri.hostname, $case[1]);
      expect(uri.origin, 'at://${$case[1]}');
      expect(uri.pathname, $case[2]);
      // TODO: searchParams
      expect(uri.hash, $case[4]);
    }
  });

  test('handles ATP-specific parsing', () {
    final uri = AtUri.parse('at://foo.com/com.example.foo/123');

    expect(uri.collection, 'com.example.foo');
    expect(uri.rkey, '123');
  });
}
