part of '../pubspec/internal_parts.dart';

/// Each line read from the pubspec.yaml is assigned a
/// [LineType]
enum LineType {
  // a blank line
  blank,
  // A single line comment starts with #
  comment,
  // key to map
  key,
  // indexed line - starts with -
  indexed,

  // a mulit-line string
  multiline,

  /// A line type that isn't recognized
  /// The pubspec specification allows other data
  /// to be stored in the pubspec so if we don't recognize
  /// the type of line we mark it as unknown and simply pass
  /// the data through unmodified.
  unknown;
}
