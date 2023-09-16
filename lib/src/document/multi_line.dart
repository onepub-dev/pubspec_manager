import 'comments.dart';
import 'line.dart';
import 'section.dart';

/// Used to hold a single line that can have a multi-line scalar
/// value. Currently only supported for the desription field.
///
/// We support three forms of scalar.
/// A simple key/value pair
/// A plain scalar - following on line(s) that is indented two charcaters
/// A folded block scalar - key with the form 'key: >-'
/// with subsequent lines indentedy by two chacters.
/// A folded block scalar can contain a '#' which isn't treated as the
/// start of a comment.
///
/// All scalars are terminated by a new section indented to the same
/// depth of the parent.
/// Scalars may include blank lines.
class MultiLine extends Line implements Section {
  MultiLine.fromLine(super.line)
      : key = line.key,
        super.copy() {
    comments = Comments(this);
  }
  MultiLine.missing(super.document, this.key) : super.missing() {
    comments = Comments.empty(this);
  }

  @override
  String key;

  @override
  Line get line => this;

  @override
  List<Line> get lines => [...comments.lines, line];

  @override
  late final Comments comments;
}
