part of 'internal_parts.dart';

/// Describes the pubspec 'description' key
/// and allows you to manage the contents of the description key
///
/// ```dart
/// pubspec.description.set('This is my new package');
/// ```
class Description extends MultiLine {
  Description._fromLine(super.line) : super.fromLine();
  Description._missing(Document document) : super.missing(document, _key);

  Description._fromString(Document document, String description)
      : super.fromLine(document.append(LineDetached('$_key: $description')));

  factory Description._fromDocument(Document document) {
    final line = document.getLineForKey(_key);
    if (line.missing) {
      return Description._missing(document);
    }
    return Description._fromLine(line.headerLine);
  }

  static const String _key = 'description';
}
