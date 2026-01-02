import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

void main() {
  test('hosted dependency ...', ()  {
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
    final pubspec = PubSpec.loadFromString(content);
    expect(pubspec.dependencies.length, equals(1));

    final one = pubspec.dependencies.list.first;
    expect(one is DependencyAltHosted, isTrue);
    final hosted = one as DependencyAltHosted;
    expect(hosted.name, equals('dcli'));
    expect(hosted.versionConstraint, equals('1.1.1'));
    expect(hosted.hostedUrl, equals('https://onepub.dev'));

    // final two = pubspec.dependencies.elementAt(1);
    // expect(two is HostedDependency, isTrue);
    // expect(two.name, equals('dcli_core'));
    // expect((two as HostedDependency).version,
    //     equals(VersionConstraint.parse('2.3.1')));
  });

  test('hosted dependency missing version defaults to any', () {
    const content = '''
name: one
environment:
  sdk: 1.2.3
dependencies:
  dcli:
    hosted: https://onepub.dev
''';
    final pubspec = PubSpec.loadFromString(content);
    final hosted = pubspec.dependencies.list.first as DependencyAltHosted;

    expect(hosted.versionConstraint, equals('any'));
    expect(hosted.hostedUrl, equals('https://onepub.dev'));
  });
}
