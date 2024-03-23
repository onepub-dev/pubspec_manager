import 'dart:io';

import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

import '../util/with_temp_file.dart';

typedef SetAction = void Function(PubSpec pubspec, String value);
typedef GetAction = String Function(PubSpec pubspec);

// Create a pubspec in memory and then add
// a new key
Future<void> create(
    {required SetAction set,
    required GetAction get,
    required String key,
    required String value,
    bool nameOnly = false}) async {
  // create the pubspec in memory and
  // then add a new key/value
  final pubspec = PubSpec(name: 'test');
  set(pubspec, value);

  /// Load the pubspec from disk and make certain
  /// the value exists
  await withTempFile((tempFile) async {
    pubspec.saveTo(tempFile);
    _hasExpectedLines(tempFile, key, value, nameOnly: nameOnly);

    final reloaded = PubSpec.loadFromPath(tempFile);
    expect(get(reloaded), equals(value));
  });
}

/// create an in-memory pubspec with an existing key
/// update the value of that key.
/// Then do the same from disk.
Future<void> update(
    {required SetAction set,
    required GetAction get,
    required String key,
    required String value,
    required String newValue,
    bool nameOnly = false}) async {
  final sample = nameOnly
      ? '''
name: $value'''
      : '''
name: test
$key: $value''';

  /// Create the pubspec in memory and add
  /// a update an existing key
  final pubspec = PubSpec.loadFromString(sample);
  expect(pubspec.document.lines.length, equals(nameOnly ? 1 : 2));
  expect(get(pubspec), equals(value));
  set(pubspec, newValue);

  expect(get(pubspec), equals(newValue));
  expect(pubspec.document.lines.length, equals(nameOnly ? 1 : 2));

  /// load the resulting pubspec from disk
  /// make certain the update value was saved.
  await withTempFile((tempFile) async {
    pubspec.saveTo(tempFile);
    _hasExpectedLines(tempFile, key, newValue, nameOnly: nameOnly);

    /// reload the pubspec and see the value is visible
    var reloaded = PubSpec.loadFromPath(tempFile);
    expect(get(reloaded), equals(newValue));

    // check that the update works after loading from disk
    set(pubspec, value);
    pubspec.saveTo(tempFile);
    reloaded = PubSpec.loadFromPath(tempFile);
    expect(get(reloaded), equals(value));

    await _checkMingled(
        set: set,
        get: get,
        key: key,
        value: value,
        newValue: newValue,
        nameOnly: nameOnly);
  });
}

Future<void> _checkMingled(
    {required SetAction set,
    required GetAction get,
    required String key,
    required String value,
    required String newValue,
    required bool nameOnly}) async {
  /// Check that update works when we are not the last line in the file
  final sampleLonger = nameOnly
      ? '''
name: $value
description: |
  a sample app
  '''
      : '''
name: test
$key: $value
description: |
  a sample app
  ''';

  final pubspec = PubSpec.loadFromString(sampleLonger);
  set(pubspec, newValue);
  await withTempFile((tempFile) async {
    pubspec.saveTo(tempFile);

    final reloaded = PubSpec.loadFromPath(tempFile);
    expect(get(reloaded), equals(newValue));
    expect(pubspec.description.value, equals('a sample app'));
  });
}

void _hasExpectedLines(String tempFile, String key, String newValue,
    {required bool nameOnly}) {
  final lines = File(tempFile).readAsLinesSync();
  expect(lines.length, equals(nameOnly ? 1 : 2));

  if (nameOnly) {
    expect(lines[0], equals('name: $newValue'));
  } else {
    expect(lines[0], equals('name: test'));
    expect(lines[1], equals('$key: $newValue'));
  }
}
