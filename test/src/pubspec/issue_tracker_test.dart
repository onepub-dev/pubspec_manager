import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

import 'set_and_update.dart';

void main() {
  const url = 'https://xx.y';
  group('issueTracker ...', () {
    test('create', () async {
      await create(
          get: (pubspec) => pubspec.issueTracker.value,
          set: (pubspec, value) => pubspec.issueTracker.set(value),
          key: IssueTracker.keyName,
          value: url);

      await update(
          set: (pubspec, value) => pubspec.issueTracker.set(value),
          get: (pubspec) => pubspec.issueTracker.value,
          key: IssueTracker.keyName,
          value: url,
          newValue: 'https//:new.home');
    });
  });
}
