import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

import 'set_and_update.dart';

void main() {
  const url = 'https://xx.y';
  group('repository ...', () {
    test('create', () async {
      await create(
          get: (pubspec) => pubspec.repository.value,
          set: (pubspec, value) => pubspec.repository.set(value),
          key: Repository.keyName,
          value: url);

      await update(
          set: (pubspec, value) => pubspec.repository.set(value),
          get: (pubspec) => pubspec.repository.value,
          key: Repository.keyName,
          value: url,
          newValue: 'https//:new.home');
    });
  });
}
