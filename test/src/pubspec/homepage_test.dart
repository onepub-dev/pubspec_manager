import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

import 'set_and_update.dart';

void main() {
  const url = 'https://home.y';
  group('homepage ...', () {
    test('create', () async {
      await create(
          get: (pubspec) => pubspec.homepage.value,
          set: (pubspec, value) => pubspec.homepage.set(value),
          key: Homepage.keyName,
          value: url);

      await update(
          set: (pubspec, value) => pubspec.homepage.set(value),
          get: (pubspec) => pubspec.homepage.value,
          key: Homepage.keyName,
          value: url,
          newValue: 'https//:new.home');
    });

    test('comments', () {
      final pubspec = PubSpec(name: 'test');
      pubspec.homepage
        ..set('http://x')
        ..comments.append('line 2')
        ..comments.append('line 3');
    });
  });
}
