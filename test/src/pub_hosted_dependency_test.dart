import 'package:eric/eric.dart';
import 'package:eric/src/document/line.dart';
import 'package:test/test.dart';

import 'pubspec_test.dart';

void main() {
  test('pub hosted dependency ...', () async {
    final pubspec = Pubspec.fromString(goodContent);
    expect(pubspec.dependencies.length, equals(2));

    final one = pubspec.dependencies.list.first;
    expect(one is PubHostedDependency, isTrue);
    expect(one.name, equals('dcli'));
    expect((one as PubHostedDependency).versionConstraint.toString(),
        equals('2.3.0'));

    final two = pubspec.dependencies.list.elementAt(1);
    expect(two is PubHostedDependency, isTrue);
    expect(two.name, equals('dcli_core'));
    expect((two as PubHostedDependency).versionConstraint.toString(),
        equals('2.3.1'));
  });
  test('hosted dependency ...', () async {
    const content = '''
name: one
description: something : and something else
environment:
  sdk: 1.2.3
dependencies:
  dcli:
    hosted: https://onepub.dev
    version: 1.1.1
''';
    final pubspec = Pubspec.fromString(content);
    expect(pubspec.dependencies.length, equals(1));

    final one = pubspec.dependencies.list.first;
    expect(one is HostedDependency, isTrue);
    expect(one.name, equals('dcli'));
    expect(
        (one as HostedDependency).versionConstraint,
        equals(Version.parseVersionConstraint(
            Line.test(pubspec.document, 'verson:1.1.1'), '1.1.1')));
    expect(one.hostedUrl, equals('https://onepub.dev'));

    // final two = pubspec.dependencies.elementAt(1);
    // expect(two is HostedDependency, isTrue);
    // expect(two.name, equals('dcli_core'));
    // expect((two as HostedDependency).version,
    //     equals(VersionConstraint.parse('2.3.1')));
  });
}
