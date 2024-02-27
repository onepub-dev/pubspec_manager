import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

import 'set_and_update.dart';

void main() {
  const version = '1.0.1';
  group('version to ...', () {
    test('create', () async {
      await create(
          get: (pubspec) => pubspec.version.value,
          set: (pubspec, value) => pubspec.version.set(value),
          key: Version.keyName,
          value: version);

      await update(
          set: (pubspec, value) => pubspec.version.set(value),
          get: (pubspec) => pubspec.version.value,
          key: Version.keyName,
          value: version,
          newValue: '1.1.0');
    });
  });
}
