import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

import '../pubspec_test.dart';

void main() {
  test('pub hosted dependency ...', ()  {
    final pubspec = PubSpec.loadFromString(goodContent);
    expect(pubspec.dependencies.length, equals(3));

    final one = pubspec.dependencies.list.first;
    expect(one is DependencyPubHosted, isTrue);
    var pubHosted = one as DependencyPubHosted;
    expect(one.name, equals('dcli'));
    expect(pubHosted.versionConstraint, equals('2.3.0'));

    final two = pubspec.dependencies.list.elementAt(1);
    expect(two is DependencyPubHosted, isTrue);
    pubHosted = two as DependencyPubHosted;
    expect(two.name, equals('dcli_core'));
    expect(pubHosted.versionConstraint, equals('2.3.1'));

    final three = pubspec.dependencies.list.elementAt(2);
    expect(three is DependencySdk, isTrue);
    final sdk = three as DependencySdk;
    expect(three.name, equals('flutter'));
    expect(sdk.name, equals('flutter'));
  });
}
