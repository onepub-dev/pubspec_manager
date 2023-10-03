import 'comments.dart';
import 'document.dart';
import 'line.dart';
import 'line_type.dart';
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
class MultiLine implements Section {
  MultiLine.fromLine(this.line)
      : missing = false,
        key = line.key,
        document = line.document {
    comments = Comments(this);
  }
  MultiLine.missing(this.document, this.key)
      : missing = true,
        line = Line.missing(document, LineType.key) {
    comments = Comments.empty(this);
  }

  @override
  bool missing;

  String key;

  @override
  Document document;

  @override
  Line line;

  @override
  List<Line> get lines => [...comments.lines, line];

  @override
  late final Comments comments;

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;

  String get value => line.value;
}
