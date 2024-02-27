// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

import '../util/with_temp_file.dart';

void main() {
  const simple = '''
name: eric
version: 0.0.1
description: A simple command-line application created by dcli
environment: 
  sdk: '>=2.19.0 <3.0.0'
''';

  const simpleExpected = 'A simple command-line application created by dcli';

  const flowPlainScalarDescInput = '''
A simple command-line application created by dcli
  second line
  third lien''';

  const flowPlainScalarDescExpected = '''
A simple command-line application created by dcli second line third lien''';

  const plainScalar = '''
name: eric
version: 0.0.1
description: $flowPlainScalarDescInput
environment: 
  sdk: '>=2.19.0 <3.0.0'
dependencies:
  dcli:
''';

  const foldedBlockScalar = '''
name: eric
version: 0.0.1
description: >-
  A simple command-line application created by dcli
  Second line
  Third line
environment: 
  sdk: '>=2.19.0 <3.0.0'
dependencies:
  dcli:
''';

  group('description', () {
    test('create single', () async {
      final pubspec = PubSpec(name: 'test');
      pubspec.description.set('This is a pubspec');

      await withTempFile((tempFile) async {
        pubspec.saveTo(tempFile);
        final lines = File(tempFile).readAsLinesSync();
        expect(lines.length, equals(2));
        expect(lines[0], equals('name: test'));
        expect(lines[1], equals('description: This is a pubspec'));
      });
    });

    test('update single', () async {
      const sample = '''
name: test
description: this here pubspec
      ''';
      final pubspec = PubSpec.loadFromString(sample);
      expect(pubspec.document.lines.length, equals(2));
      expect(pubspec.description.value, equals('this here pubspec'));
      const newDescription = 'This is a pubspec';
      pubspec.description.set(newDescription);

      expect(pubspec.description.value, equals(newDescription));
      expect(pubspec.document.lines.length, equals(2));

      await withTempFile((tempFile) async {
        pubspec.saveTo(tempFile);
        final lines = File(tempFile).readAsLinesSync();
        expect(lines.length, equals(2));
        expect(lines[0], equals('name: test'));
        expect(lines[1], equals('description: $newDescription'));
      });
    });

    test('create multi-line', () async {
      final pubspec = PubSpec(name: 'test');
      pubspec.description.set('''
This is a pubspec
With some more text''');

      await withTempFile((tempFile) async {
        pubspec.saveTo(tempFile);
        final lines = File(tempFile).readAsLinesSync();
        expect(lines.length, equals(4));
        expect(lines[0], equals('name: test'));
        expect(lines[1], equals('description: |'));
        expect(lines[2], equals('  This is a pubspec'));
        expect(lines[3], equals('  With some more text'));
      });
    });

    test('update multi-line', () async {
      const sample = '''
name: test
description: |
  this here pubspec''';
      final pubspec = PubSpec.loadFromString(sample);
      expect(pubspec.document.lines.length, equals(3));
      expect(pubspec.description.value, equals('this here pubspec'));
      const newDescription = '''
This is a pubspec
With some more text''';
      pubspec.description.set(newDescription);

      expect(pubspec.description.value, equals(newDescription));
      expect(pubspec.document.lines.length, equals(4));

      await withTempFile((tempFile) async {
        pubspec.saveTo(tempFile);
        final lines = File(tempFile).readAsLinesSync();
        expect(lines.length, equals(4));
        expect(lines[0], equals('name: test'));
        expect(lines[1], equals('description: |'));
        expect(lines[2], equals('  This is a pubspec'));
        expect(lines[3], equals('  With some more text'));
      });
    });
  });

  group('description', () {
    test('simple ...', () async {
      final pubspec = PubSpec.loadFromString(simple);

      expect(pubspec.description.value,
          equals('A simple command-line application created by dcli'));
    });

    test('plainScalar', () {
      final pubspec = PubSpec.loadFromString(simple);

      expect(pubspec.description.value, equals(simpleExpected));
    });
  });
}
