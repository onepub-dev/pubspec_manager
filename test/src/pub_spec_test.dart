import 'dart:io';

import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

import 'util/with_temp_file.dart';

void main() {
  group('pubspec', () {
    test('update single line attributes', () async {
      final pubspec = PubSpec.loadFromString('''
name: test
version: 1.1.1
description: test
environment: 
  sdk: 1.1.1
''');

      pubspec.name.value = 'test2';
      expect(pubspec.name.value, equals('test2'));
      expect(pubspec.document.lines[0].text, equals('name: test2'));
    });

    test('failed load reports path', () async {
      await withTempFile((tempFile) async {
        /// create a bad pubspec
        await File(tempFile).writeAsString('''
bad pubspec
''');
        expect(
            () => PubSpec.loadFromPath(tempFile),
            throwsA(isA<PubSpecException>().having(
              (e) => e.document!.pathTo,
              'path',
              equals(tempFile),
            )));
      });
    });
  });
}
