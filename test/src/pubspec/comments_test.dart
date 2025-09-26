import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

const content = '''
name: pubspec3
version: 0.0.1
description: A simple command-line application created by dcli
environment: 
  sdk: '>=2.19.0 <3.0.0'
dependencies: 
  # comment
  dcli: 2.3.0
  money: 1.0.0

#comment 2
dev_dependencies:

''';
void main() {
  test('dependency append', ()  {
    const version = '1.5.1';
    final pubspec = PubSpec.loadFromString(content);
    final devDependencies = pubspec.devDependencies
      ..add(
          DependencyBuilderPubHosted(name: 'test', versionConstraint: version));
    expect(devDependencies.exists('test'), isTrue);
    final testDep = devDependencies['test'];
    expect(testDep != null, isTrue);
    expect(testDep!.lineNo, equals(13));
    expect(testDep, isA<DependencyVersioned>());
    expect((testDep as DependencyVersioned).versionConstraint, equals(version));

    final dependencies = pubspec.dependencies
      ..add(DependencyBuilderPubHosted(
          name: 'dcli_core', versionConstraint: version));
    expect(dependencies.exists('dcli_core'), isTrue);
    final dcliCore = dependencies['dcli_core'];
    expect(dcliCore != null, isTrue);
    expect(dcliCore!.lineNo, equals(10));
    expect(dcliCore, isA<DependencyVersioned>());
    expect(
        (dcliCore as DependencyVersioned).versionConstraint, equals(version));
    expect(pubspec.document.lines.length, equals(15));
  });

  test('dependency remove last', ()  {
    final pubspec = PubSpec.loadFromString(content);
    final dependencies = pubspec.dependencies..remove('money');
    final dcli = dependencies['money'];
    expect(dcli == null, isTrue);
  });

  test('dependency remove first', ()  {
    final pubspec = PubSpec.loadFromString(content);
    final dependencies = pubspec.dependencies..remove('dcli');
    final dcli = dependencies['dcli'];
    expect(dcli == null, isTrue);
    print(pubspec);
  });

  test('dependency add comment', ()  {
    final pubspec = PubSpec.loadFromString(content);
    final dependencies = pubspec.dependencies;
    final dcli = dependencies['dcli'];
    dcli!.comments.append('Hellow World for dcli');
    expect(dcli.comments.length, equals(2));
    print(pubspec);
  });

  test('dependency removeAll comments', ()  {
    final pubspec = PubSpec.loadFromString(content);
    final document = pubspec.document;
    expect(document.lines.length, equals(13));

    final dependencies = pubspec.dependencies;
    final dcli = dependencies['dcli'];
    dcli!.comments.removeAll();
    expect(dcli.comments.length, equals(0));
    expect(document.lines.length, equals(12));
  });

  test('dependency removeAt comments', ()  {
    final pubspec = PubSpec.loadFromString(content);
    final document = pubspec.document;
    expect(document.lines.length, equals(13));

    final dependencies = pubspec.dependencies;
    final dcli = dependencies['dcli'];
    dcli!.comments.append('Hellow World for dcli');
    dcli.comments.removeAt(0);
    dcli.comments.removeAt(0);
    expect(dcli.comments.length, equals(0));
    expect(document.lines.length, equals(12));
  });

  test('dependency removeAt invalid ', ()  {
    final pubspec = PubSpec.loadFromString(content);
    final dependencies = pubspec.dependencies;
    final dcli = dependencies['dcli'];

    dcli!.comments.removeAt(0);
    expect(() => dcli.comments.removeAt(0), throwsA(isA<RangeError>()));
  });
  test('dependency removeAll empty list ', ()  {
    final pubspec = PubSpec.loadFromString(content);
    final document = pubspec.document;

    final dependencies = pubspec.dependencies;
    final dcli = dependencies['dcli'];

    dcli!.comments.removeAll();
    dcli.comments.removeAll();
    expect(dcli.comments.length, equals(0));
    expect(document.lines.length, equals(12));
  });

  test('Issue #17', () {
    const pubspec = '''
environment:
  sdk: ">=3.1.2 <4.0.0"
  flutter: ^3.22.3

dependencies:
  # A comment with leading whitespace works correctly here.
  provider:
    # But a comment with leading whitespace does not get parsed correctly here.
    # path: ../provider
    hosted:
      url: https://pub.dartlang.org
      version: ^6.1.4
  pubspec_manager:
# However, if there's no leading whitespace before the comment, it works fine.
# path: ../pubspec_manager
    hosted:
      url: https://pub.dartlang.org
      version: ^1.0.1
      ''';
    PubSpec.loadFromString(pubspec);
  });
}
