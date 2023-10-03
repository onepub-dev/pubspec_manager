import 'package:eric/eric.dart';
import 'package:eric/src/document/line.dart';
import 'package:test/test.dart';

void main() {
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
    expect(one is HostedDependencyAttached, isTrue);
    final hosted = one as HostedDependencyAttached;
    expect(hosted.name, equals('dcli'));
    expect(
        hosted.version,
        equals(VersionAttached.parseVersionConstraint(
            Line.test(pubspec.document, 'verson:1.1.1'), '1.1.1')));
    expect(hosted.hostedUrl, equals('https://onepub.dev'));

    // final two = pubspec.dependencies.elementAt(1);
    // expect(two is HostedDependency, isTrue);
    // expect(two.name, equals('dcli_core'));
    // expect((two as HostedDependency).version,
    //     equals(VersionConstraint.parse('2.3.1')));
  });
}
