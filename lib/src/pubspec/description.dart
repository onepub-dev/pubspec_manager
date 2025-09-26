part of 'internal_parts.dart';

/// Describes the pubspec 'description' key
/// and allows you to manage the contents of the description key
///
/// ```dart
/// pubspec.description.set('This is my new package');
/// ```
class Description implements Section {
  /// the section that this entry is associated with.
  MultiLine _multiLine;

  static const keyName = 'description';

  Description._fromLine(LineImpl line) : _multiLine = MultiLine.fromLine(line);

  Description._missing(Document document)
      : _multiLine = MultiLine.missing(document, keyName);

  Description._fromString(Document document, String description)
      : _multiLine = MultiLine.fromLine(
            document.append(LineDetached('$keyName: $description')));

  factory Description._fromDocument(Document document) {
    final line = document.getLineForKey(keyName);
    if (line.missing) {
      return Description._missing(document);
    }
    return Description._fromLine(line.headerLine);
  }

  @override
  Comments get comments => _multiLine.comments;

  @override
  List<Line> get lines => _multiLine.lines;

  @override
  bool get missing => _multiLine.missing;

  /// Replace the existing string.
  /// [value] may contain newlines in which case
  /// we will write out a multi-line yaml scalar string.
  /// ```yaml
  /// description: |
  ///   first line
  ///   second line
  /// ```
  void set(String value) => _multiLine.set(value);

  /// Returns the content of the description which could include newlines.
  String get value => _multiLine.value;
}
