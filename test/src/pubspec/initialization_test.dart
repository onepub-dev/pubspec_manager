import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

void main() {
  test('dependency add works for git dependencies', () {
    final pubspec = PubSpec.loadFromString('''
name: test
environment:
  sdk: 1.0.0
''');

    pubspec.dependencies
        .add(DependencyBuilderGit(
          name: 'git_dep',
          url: 'https://example.com/repo.git',
          ref: 'main',
        ))
        .add(DependencyBuilderPubHosted(
          name: 'second',
          versionConstraint: '^1.0.0',
        ));

    expect(pubspec.dependencies.exists('second'), isTrue);
  });

  test('dependency add works for path dependencies', () {
    final pubspec = PubSpec.loadFromString('''
name: test
environment:
  sdk: 1.0.0
''');

    pubspec.dependencies
        .add(DependencyBuilderPath(
          name: 'path_dep',
          path: '../path_dep',
        ))
        .add(DependencyBuilderPubHosted(
          name: 'second',
          versionConstraint: '^1.0.0',
        ));

    expect(pubspec.dependencies.exists('second'), isTrue);
  });

  test('dependency add works for sdk dependencies', () {
    final pubspec = PubSpec.loadFromString('''
name: test
environment:
  sdk: 1.0.0
''');

    pubspec.dependencies
        .add(DependencyBuilderSdk(
          name: 'flutter',
          path: 'flutter',
        ))
        .add(DependencyBuilderPubHosted(
          name: 'second',
          versionConstraint: '^1.0.0',
        ));

    expect(pubspec.dependencies.exists('second'), isTrue);
  });

  test('missing platforms remove throws PlatformNotFound', () {
    final pubspec = PubSpec(name: 'test');
    expect(
      () => pubspec.platforms.remove(PlatformEnum.android),
      throwsA(isA<PlatformNotFound>()),
    );
  });

  test('version constraint builder missing/empty comments are safe', () {
    final missing = VersionConstraintBuilder.missing();
    final empty = VersionConstraintBuilder.empty();

    expect(missing.comments, isEmpty);
    expect(empty.comments, isEmpty);
  });
}
