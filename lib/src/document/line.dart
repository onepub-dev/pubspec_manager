part of '../pubspec/internal_parts.dart';

// ignore: one_member_abstracts
abstract class Renderer {
  String render();
}

/// Represents a line of text in the [Document] that is
/// used to load and manipulate the pubspec.yaml.
abstract class Line {
  /// The full ine of text from the document.
  String get text;

  /// The line number of this line from within the document.
  /// The first [lineNo] is 1.
  int get lineNo;

  /// The indentation level of this line. Top level key's
  /// have an indentation of 0.
  int get indent;

  /// The type of line
  LineType get lineType;

  /// Used when one of the find operations is called
  /// by no matching line was found.
  bool get missing;

  /// If the [lineType] is [LineType.key] then this will
  /// hold the key.
  /// e.g.
  /// ```yaml
  /// homepage: https://somehthing
  /// ```
  /// In the above example [key] will be 'homepage'.
  String get key;

  /// If the [lineType] is [LineType.key] then this will
  /// hold the value.
  /// e.g.
  /// ```yaml
  /// homepage: https://somehthing
  /// ```
  /// In the above example [value] will be 'https://somehthing'.
  String get value;

  /// If the [text] contains a trailing comment then this field
  /// will hold the comment.
  /// ```yaml
  /// name: my package # it's really my package.
  /// ```
  String? get inlineComment;

  /// Zero based index to the [inlineComment] from the
  /// start of the [text]. Null if the [Line] does not contain
  /// an inline comment.
  int? get commentOffset;
}
