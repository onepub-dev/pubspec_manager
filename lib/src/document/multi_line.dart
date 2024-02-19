import 'line_detached.dart';
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
class MultiLine extends SectionImpl implements Section {
  MultiLine.fromLine(super.line) : super.fromLine();
  MultiLine.missing(super.document, super.key) : super.missing();

  // List<Line> get lines => [...comments.lines, line];

  String get value => line.value;

  // ignore: use_setters_to_change_properties
  void set(String value) {
    if (missing) {
       final detached = LineDetached('$key: $value');
      line = document.append(detached);
      missing = false;
    } else {
      super.line.value = '$key: $value';
    }
  }
}
