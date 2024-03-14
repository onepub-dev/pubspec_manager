part of 'internal_parts.dart';

class Name extends SectionSingleLine {
  /// build name from an imported document line
  factory Name._fromDocument(Document document) {
    final lineSection = document.getLineForKey(Name.keyName);
    if (lineSection.missing) {
      return Name.missing(document);
    } else {
      return Name._(lineSection.headerLine);
    }
  }

  Name._fromString(Document document, String name)
      : super._appendLine(document, 0, keyName, name);

  Name._(super.line) : super.fromLine();

  Name.missing(Document document) : super.missing(document, 0, keyName);

  // ignore: avoid_renaming_method_parameters
  Name set(String name) {
    super.value = name;

    // ignore: avoid_returning_this
    return this;
  }

  static const String keyName = 'name';
}
