import 'dart:convert';

import 'package:strings/strings.dart';

import 'document.dart';
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
  MultiLine.fromLine(super.sectionHeading) : super.fromLine();
  MultiLine.missing(super.document, super.key) : super.missing();

  factory MultiLine.fromDocument(Document document, String key) {
    final line = document.getLineForKey(key);
    if (line.missing) {
      return MultiLine.missing(document, key);
    }
    return MultiLine.fromLine(line.sectionHeading);
  }

  // List<Line> get lines => [...comments.lines, line];

  String get value => sectionHeading.value;

  // ignore: use_setters_to_change_properties
  void set(String value) {
    /// we are not going to write out whitespace.
    if (Strings.isBlank(value)) {
      value = '';
    }

    final valueLines = LineSplitter.split(value);

    final lines = <LineDetached>[];
    if (valueLines.length == 1) {
      lines.add(LineDetached('$key: $value'));
    } else {
      // start a multi-line segment
      lines.add(LineDetached('$key: |'));

      for (final line in valueLines) {
        lines.add(LineDetached('  $line'));
      }
    }
    if (missing) {
      super.sectionHeading = document.append(lines[0]);
      missing = false;
    } else {
      super.sectionHeading.value = lines[0].text;
    }
  }
}
