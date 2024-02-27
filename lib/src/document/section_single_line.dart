part of '../pubspec/internal_parts.dart';

/// A section which is a single line with no children
/// but which can have comments.
class SectionSingleLine extends SectionImpl implements Section {
  SectionSingleLine.fromLine(super.sectionHeading)
      : _indent = sectionHeading.indent,
        super.fromLine();

  SectionSingleLine.attach(
      PubSpec pubspec, Line lineBefore, this._indent, String key, String value)
      : super.fromLine(LineImpl.forInsertion(
            pubspec.document, LineImpl.buildLine(_indent, key, value))) {
    document.insertAfter(headerLine, lineBefore);
  }

  SectionSingleLine._appendLine(
      Document document, this._indent, String key, String value)
      : super.missing(document, key) {
    document.append(LineDetached(LineImpl.buildLine(_indent, key, value)));
  }

  SectionSingleLine.missing(super.document, this._indent, super.key)
      : super.missing();

  final int _indent;

  String get value => headerLine.value;

  set value(String value) {
    if (missing) {
      final detached = LineDetached(LineImpl.buildLine(_indent, key, value));
      headerLine = document.append(detached);
      missing = false;
    } else {
      headerLine.value = value;
    }
  }
}

abstract class SingleLine {
  String get value;
}
