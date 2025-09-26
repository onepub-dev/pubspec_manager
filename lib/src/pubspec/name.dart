part of 'internal_parts.dart';

/// Describes the name of the package.
///
/// To modify the name of the package:
///
/// ```dart
/// final pubspec = PubSpec.load();
/// pubspec.name.set('a_new_name');
/// pubspec.save();
/// ```
///
///
class Name implements Section {
  SectionSingleLine _section;

  static const keyName = 'name';

  /// build name from an imported document line
  factory Name._fromDocument(Document document) {
    final lineSection = document.getLineForKey(Name.keyName);
    if (lineSection.missing) {
      return Name._missing(document);
    } else {
      return Name._(lineSection.headerLine);
    }
  }

  Name._fromString(Document document, String name)
      : _section = SectionSingleLine.appendLine(document, 0, keyName, name);

  Name._(LineImpl line) : _section = SectionSingleLine.fromLine(line);

  Name._missing(Document document)
      : _section = SectionSingleLine.missing(document, 0, keyName);

  /// Set the package's name.
  Name set(String name) {
    _section.value = name;

    return this;
  }

  /// Get the package's name.
  String get value => _section.value;

  @override
  Comments get comments => _section.comments;

  @override
  List<Line> get lines => _section.lines;

  @override
  bool get missing => _section.missing;
}
