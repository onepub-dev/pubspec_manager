import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

import '../pubspec_test.dart';

void main() {
  group('git', () {
    const gitDependency = 'kittens';
    const gitUrl = 'https://github.com/munificent/kittens.git';
    const gitRef = 'branch';
    const gitPath = 'path/to/kittens';
    test('Simple git dependency', () {
      const content = '''
name: pubspec3
version: 0.0.1
environment: 
  sdk: '>=2.19.0 <3.0.0'
dependencies: 
  $gitDependency:
    git: $gitUrl
  flutter: 
    sdk: flutter
''';

      final pubspec = PubSpec.loadFromString(content);
      final dependency = pubspec.dependencies[gitDependency];

      expect(dependency, isNotNull);
      expect(
          dependency,
          isA<DependencyGit>()
              .having((gitDep) => gitDep.url, 'url', equals(gitUrl)));
    });
    test('Composed git dependency', () {
      const content = '''
name: pubspec3
version: 0.0.1
environment: 
  sdk: '>=2.19.0 <3.0.0'
dependencies: 
  $gitDependency:
    git:
      url: $gitUrl
      ref: $gitRef
      path: $gitPath
  flutter: 
    sdk: flutter
''';

      final pubspec = PubSpec.loadFromString(content);
      final dependency = pubspec.dependencies[gitDependency];

      expect(dependency, isNotNull);
      expect(
          dependency,
          isA<DependencyGit>()
              .having((gitDep) => gitDep.url, 'url', equals(gitUrl))
              .having((gitDep) => gitDep.ref, 'ref', equals(gitRef))
              .having((gitDep) => gitDep.path, 'path', equals(gitPath)));
    });
    test('Git dependency missing url', () {
      const content = '''
name: pubspec3
version: 0.0.1
environment: 
  sdk: '>=2.19.0 <3.0.0'
dependencies: 
  $gitDependency:
    git:
      ref: $gitRef
      path: $gitPath
  flutter: 
    sdk: flutter
''';
      expect(
          () => PubSpec.loadFromString(content),
          throwsA(isA<PubSpecException>().having(
              (e) => e.message,
              'Error message',
              equals(
                  '''The git dependency for '$gitDependency' requires a value or a 'url' key.'''))));
    });
    test('Git dependency url specified twice', () {
      const content = '''
name: pubspec3
version: 0.0.1
environment: 
  sdk: '>=2.19.0 <3.0.0'
dependencies: 
  $gitDependency:
    git: $gitUrl
      url: $gitUrl
      ref: $gitRef
      path: $gitPath
  flutter: 
    sdk: flutter
''';

      expect(
          () => PubSpec.loadFromString(content),
          throwsA(isA<PubSpecException>().having(
              (e) => e.message,
              'Error message',
              equals(
                  '''The git dependency for '$gitDependency' has the url specified twice. '''))));
    });

    test('Add git dependency', () {
      const testContent = '''
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
  $gitDependency:
    git:
      url: $gitUrl
      ref: $gitRef
      path: $gitPath
  
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
      final pubspec = PubSpec.loadFromString(goodContent);

      pubspec.dependencies.add(
        DependencyBuilderGit(
          name: gitDependency,
          url: gitUrl,
          path: gitPath,
          ref: gitRef,
        ),
      );

      expect(pubspec.toString(), equals(testContent));
    });
    test('Add simple git dependency', () {
      const testContent = '''
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
  $gitDependency:
    git: $gitUrl
  
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
      final pubspec = PubSpec.loadFromString(goodContent);

      pubspec.dependencies.add(
        DependencyBuilderGit(
          name: gitDependency,
          url: gitUrl,
        ),
      );

      expect(pubspec.toString(), equals(testContent));
    });
  });
  test('#16', () {
    const pubspecPath = 'test/artifacts/butterfly.pubspec.yaml';
    print('pubspec Path $pubspecPath');
    // ensureFlutter();

    const name = 'my_package';
    print('Add dependency $name');
    final pubspec = PubSpec.loadFromPath(pubspecPath);
    pubspec.dependencies.add(DependencyBuilderGit(
      name: name,
      url: 'git url, is real before',
      path: 'packages/$name',
      ref: 'develop',
    ));
    print(pubspec);
    print('Write to pubspec.yaml file');
    // pubspec.save();
  });
}
