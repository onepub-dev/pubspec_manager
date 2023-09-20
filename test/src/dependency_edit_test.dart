import 'package:eric/eric.dart';
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
  test('dependency append', () async {
    const version = '1.5.1';
    final pubspec = Pubspec.fromString(content);
    final devDependencies = pubspec.devDependencies
      ..append(PubHostedDependency(name: 'test', version: version));
    expect(devDependencies.contains('test'), isTrue);
    final testDep = devDependencies['test'];
    expect(testDep != null, isTrue);
    expect(testDep!.line.lineNo, equals(13));
    expect(testDep.versionConstraint.toString(), equals(version));

    final dependencies = pubspec.dependencies
      ..append(PubHostedDependency(name: 'dcli_core', version: version));
    expect(dependencies.contains('dcli_core'), isTrue);
    final dcliCore = dependencies['dcli_core'];
    expect(dcliCore != null, isTrue);
    expect(dcliCore!.line.lineNo, equals(10));
    expect(dcliCore.versionConstraint.toString(), equals(version));
    expect(pubspec.document.lines.length, equals(15));
  });

  test('dependency remove last', () async {
    final pubspec = Pubspec.fromString(content);
    final dependencies = pubspec.dependencies..remove('money');
    final dcli = dependencies['money'];
    expect(dcli == null, isTrue);
  });

  test('dependency remove first', () async {
    final pubspec = Pubspec.fromString(content);
    final dependencies = pubspec.dependencies..remove('dcli');
    final dcli = dependencies['dcli'];
    expect(dcli == null, isTrue);
    print(pubspec);
  });

  test('comment on dependency section', () async {
    final pubspec = Pubspec.fromString(content);
    final document = pubspec.document;
    const comment = 'A comment on section';
    pubspec.dependencies.comments.append(comment);
    expect(document.lines[5].text, '#$comment');

    expect(pubspec.dependencies.comments.length, equals(1));
  });
}
