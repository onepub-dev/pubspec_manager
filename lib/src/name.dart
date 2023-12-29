part of 'internal_parts.dart';

class Name extends SectionSingleLine {
  /// build name from an imported document line
  factory Name._fromLine(Document document) {
    final lineSection = document.getLineForKey(Name._key);
    if (lineSection.missing) {
      return Name.missing(document);
    } else {
      return Name._(lineSection.line);
    }
  }

  Name._fromString(Document document, String name)
      : super.append(document, _key, name);

  Name._(super.line) : super.fromLine();

  Name.missing(Document document) : super.missing(document, _key);

  static const String _key = 'name';
}
