import 'package:eric/eric.dart';
import 'package:test/test.dart';

import 'pubspec_test.dart';

void main() {
  test('pub hosted dependency ...', () async {
    final pubspec = Pubspec.fromString(goodContent);
    expect(pubspec.dependencies.length, equals(2));

    final one = pubspec.dependencies.list.first;
    expect(one is PubHostedDependencyAttached, isTrue);
    var pubHosted = one as PubHostedDependencyAttached;
    expect(one._name, equals('dcli'));
    expect(pubHosted._version, equals('2.3.0'));

    final two = pubspec.dependencies.list.elementAt(1);
    expect(two is PubHostedDependencyAttached, isTrue);
    pubHosted = two as PubHostedDependencyAttached;
    expect(two._name, equals('dcli_core'));
    expect(pubHosted._version, equals('2.3.1'));
  });
}
