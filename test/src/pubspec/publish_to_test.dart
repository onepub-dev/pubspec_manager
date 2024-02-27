import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

import 'set_and_update.dart';

void main() {
  const url = 'https://xx.y';
  group('publish to ...', () {
    test('create', () async {
      await create(
          get: (pubspec) => pubspec.publishTo.value,
          set: (pubspec, value) => pubspec.publishTo.set(value),
          key: PublishTo.keyName,
          value: url);

      await update(
          set: (pubspec, value) => pubspec.publishTo.set(value),
          get: (pubspec) => pubspec.publishTo.value,
          key: PublishTo.keyName,
          value: url,
          newValue: 'https//:new.home');
    });
  });
}
