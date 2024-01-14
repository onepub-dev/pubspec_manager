import 'dart:io';

import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

import 'util/read_file.dart';
import 'util/with_temp_file.dart';

const goodContent = '''
name: pubspec3
version: 0.0.1
description: A simple command-line application created by dcli
environment: 
  sdk: '>=2.19.0 <3.0.0' # an inline comment
dependencies: 
  dcli: 2.3.0
  dcli_core: 2.3.1
  flutter: 
    sdk: flutter
  
# only used during dev.
dev_dependencies: 
  lint_hard: ^3.0.0
  test: ^1.24.6

topics:
  - console
  - terminal

executables:
  dcli:
  dswitch: dswitcheroo
''';

void main() {
  group('pubspec', () {
    test('pubspec ...', () async {
      final pubspec = PubSpec.loadFromString(goodContent);

      expect(pubspec.name.value, equals('pubspec3'));
      expect(pubspec.version.value.toString(), equals('0.0.1'));
      expect(pubspec.description.value,
          equals('A simple command-line application created by dcli'));

      expect(pubspec.environment.sdk, equals("'>=2.19.0 <3.0.0'"));
      expect(pubspec.dependencies.length, equals(3));
    });

    test('save', () {
      final pubspec = PubSpec.loadFromString(goodContent)
        ..save(directory: Directory.systemTemp.path);

      print(File(pubspec.loadedFrom).readAsStringSync());
    });

    test('name only', () async {
      const content = '''
name: test_1
''';
      final pubspec = PubSpec.loadFromString(content);

      await withTempFile((output) async {
        pubspec.saveTo(output);
        expect(readFile(output), equals(content));
      });
    });

    test('name only and enviorment', () async {
      const content = '''
name: test_1
environment:
  sdk: '>=3.0.0 <4.0.0'
''';
      final pubspec = PubSpec.loadFromString(content);

      await withTempFile((output) async {
        pubspec.saveTo(output);
        expect(readFile(output), equals(content));
      });
    });
  });

  /// The # path: line was generating a duplicate line bug.
  test('Section comments', () async {
    const content = '''
  # an indented comment
# a non indented comment
name: dcli_test
environment:  # line comment
  sdk: ^3.1.3

# Add regular dependencies here.
  # in
# out
dependencies:
  fred: ^1.0.0
    # nested comment
  uuid: ^4.1.0
  # path: ^1.8.0

dev_dependencies:
  lints: ^2.0.0
  # deeply indented comment

# a trailing comment.
''';
    final pubspec = PubSpec.loadFromString(content);

    await withTempFile((output) async {
      pubspec.saveTo(output);
      expect(readFile(output), equals(content));
    });
  });
}
