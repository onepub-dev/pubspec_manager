import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

import 'set_and_update.dart';

void main() {
  group('name  ...', () {
    test('create', () async {
      await create(
          get: (pubspec) => pubspec.name.value,
          set: (pubspec, value) => pubspec.name.set(value),
          key: Name.keyName,
          value: 'new_name',
          nameOnly: true);

      await update(
          set: (pubspec, value) => pubspec.name.set(value),
          get: (pubspec) => pubspec.name.value,
          key: Name.keyName,
          value: 'old_name',
          newValue: 'new_name',
          nameOnly: true);
    });
  });
}
