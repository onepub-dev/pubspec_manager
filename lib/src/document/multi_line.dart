part of '../pubspec/internal_parts.dart';

/// Used to hold a key that can have a multi-line scalar
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
  MultiLine.fromLine(super.headerLine) : super.fromLine();
  MultiLine.missing(super.document, super.key) : super.missing();

  factory MultiLine.fromDocument(Document document, String key) {
    final line = document.getLineForKey(key);
    if (line.missing) {
      return MultiLine.missing(document, key);
    }
    return MultiLine.fromLine(line.headerLine);
  }

  // List<Line> get lines => [...comments.lines, line];

  String get value {
    if (missing) {
      return '';
    }
    final sb = StringBuffer();

    final first = lines.first.value;

    /// Is it a yaml multi-line scalar string
    final scalar = first.startsWith(RegExp(r'^\s*[|>][+-]?[1-9]?\s*'));

    if (!scalar) {
      /// If this is a scalar then the first line will have the
      /// sclar indicator (| or >) which we don't output.
      sb.write(lines.first.value);
    } else {
      for (final line in lines.skip(1)) {
        if (line == lines.last) {
          // no trailing newline on the last line.
          // This means that for a single line description we
          // don't have a trailing newline
          sb.write(line.text.trim());
        } else {
          // we strip the leading indentation as that is part of the
          // yaml structure not the string.
          sb.writeln(line.text.trim());
        }
      }
    }

    return sb.toString();
  }

  /// Replace the existing string.
  /// [value] may contain newlines in which case
  /// we will write out a multi-line yaml scalar string.
  /// ```yaml
  /// description: |
  ///   first line
  ///   second line
  /// ```
  // ignore: use_setters_to_change_properties
  void set(String value) {
    /// we are not going to write out whitespace.
    if (Strings.isBlank(value)) {
      value = '';
    }

    // remove existing child lines as we are replacing them.
    clearChildren();

    final valueLines = LineSplitter.split(value);
    final detachedLines = <LineDetached>[];

    if (valueLines.length == 1) {
      /// single line scaler (string)
      detachedLines.add(LineDetached('$key: $value'));
    } else {
      // start a multi-line scaler (string)
      detachedLines.add(LineDetached('$key: |'));

      /// each of the subsequent lines are indented.
      for (final line in valueLines) {
        detachedLines.add(LineDetached('  $line'));
      }
    }
    if (missing) {
      headerLine = document.append(detachedLines[0]);
      missing = false;
    } else {
      headerLine.value = KeyValue.fromText(detachedLines[0].text).value;
    }

    /// If the string is multi-line then append
    /// each additional line as a child.
    for (final detached in detachedLines.skip(1)) {
      appendLine(detached.attach(document, LineType.multiline));
    }
  }

  /// outputs the raw text of the line as it
  /// would appear in the pubspec.yaml
  @override
  String toString() => value;
}
