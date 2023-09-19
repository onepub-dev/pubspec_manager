import 'dart:io';

import 'package:eric/src/pubspec.dart';
import 'package:pub_semver/pub_semver.dart' as sm;
import 'package:test/test.dart';

const goodContent = '''
name: pubspec3
version: 0.0.1
description: A simple command-line application created by dcli
environment: 
  sdk: '>=2.19.0 <3.0.0' # an inline comment
dependencies: 
  dcli: 2.3.0
  dcli_core: 2.3.1
  
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
      final pubspec = PubSpec.fromString(goodContent);

      expect(pubspec.name.value, equals('pubspec3'));
      expect(pubspec.version.value, equals('0.0.1'));
      expect(pubspec.description.value,
          equals('A simple command-line application created by dcli'));

      expect(pubspec.environment.sdk.constraint,
          equals(sm.VersionConstraint.parse('>=2.19.0 <3.0.0')));

      expect(pubspec.dependencies.length, equals(2));
    });

    test('save', () {
      final pubspec = PubSpec.fromString(goodContent)
        ..save(directory: Directory.systemTemp.path);

      print(File(pubspec.loadedFrom).readAsStringSync());
    });
  });
}
