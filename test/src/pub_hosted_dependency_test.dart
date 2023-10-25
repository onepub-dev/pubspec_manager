import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

import 'pubspec_test.dart';

void main() {
  test('pub hosted dependency ...', () async {
    final pubspec = PubSpec.loadFromString(goodContent);
    expect(pubspec.dependencies.length, equals(2));

    final one = pubspec.dependencies.list.first;
    expect(one is PubHostedDependency, isTrue);
    var pubHosted = one as PubHostedDependency;
    expect(one.name, equals('dcli'));
    expect(pubHosted.version, equals('2.3.0'));

    final two = pubspec.dependencies.list.elementAt(1);
    expect(two is PubHostedDependency, isTrue);
    pubHosted = two as PubHostedDependency;
    expect(two.name, equals('dcli_core'));
    expect(pubHosted.version, equals('2.3.1'));
  });
}
