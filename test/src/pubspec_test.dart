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
    test('update single line attributes', () {
      final pubspec = PubSpec.loadFromString('''
name: test
version: 1.1.1
description: test
environment: 
  sdk: 1.1.1
''');

      pubspec.name.set('test2');
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

      /// skipping this test as I'm not actually sure what constitues
      /// a bad pubspec and wether its better to no try and enforce it
      /// given that for the most part we don't care if they
      /// have crap in the pubspec.
    }, skip: true);

    test('pubspec ...', () {
      final pubspec = PubSpec.loadFromString(goodContent);

      expect(pubspec.name.value, equals('pubspec3'));
      expect(pubspec.version.value, equals('0.0.1'));
      expect(pubspec.description.value,
          equals('A simple command-line application created by dcli'));

      expect(pubspec.environment.sdk, equals("'>=2.19.0 <3.0.0'"));
      expect(pubspec.dependencies.length, equals(3));
    });

    test('save', () {
      final pubspec = PubSpec.loadFromString(goodContent)
        ..save(directory: Directory.systemTemp.path);

      expect(File(pubspec.loadedFrom).existsSync(), isTrue);
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
  test('set all attributes', () {
    PubSpec(name: 'test')
      ..version.set('1.2.1')
      ..description.set('A description')
      ..environment.flutter = '3.3.3'
      ..environment.sdk = '3.2.5'
      ..homepage.set('https:/.hi')
      ..publishTo.set('https://pubslish to')
      ..repository.set('https;//repository')
      ..issueTracker.set('https://issues')
      ..documentation.set('https://doco')
      ..dependencies.add(DependencyBuilderPath(name: 'dcli', path: '..'))
      ..devDependencies.add(DependencyBuilderPubHosted(
          name: 'lint_hard', versionConstraint: '1.0.0'))
      ..dependencyOverrides
          .add(DependencyBuilderPath(name: 'lint_hard', path: '..'))
      ..executables.add(name: 'test').comments.append('The main exec')
      ..platforms.add(PlatformEnum.android)
      ..platforms.addAll([PlatformEnum.ios, PlatformEnum.linux]);
  });
}
