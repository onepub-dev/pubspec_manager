part of 'internal_parts.dart';

/// Defines the url to the package's homepage.
class Homepage implements Section {
  /// build homepage from an imported document line
  factory Homepage._fromDocument(Document document) {
    final lineSection = document.getLineForKey(Homepage.keyName);
    if (lineSection.missing) {
      return Homepage._missing(document);
    } else {
      return Homepage._(lineSection.headerLine);
    }
  }

  Homepage._(LineImpl line)
      : _url = line.value,
        _section = SectionSingleLine.fromLine(line);

  Homepage._missing(Document document)
      : _url = '',
        _section = SectionSingleLine.missing(document, 0, keyName);

  SectionSingleLine _section;
  String _url;

  /// Set the url to the package's homepage.
  Homepage set(String url) {
    _url = url;
    _section.value = url;
    // ignore: avoid_returning_this
    return this;
  }

  /// The url of the homepage.
  String get value => _url;

  static const String keyName = 'homepage';

  @override
  Comments get comments => _section.comments;

  @override
  List<Line> get lines => _section.lines;

  @override
  bool get missing => _section.missing;
}
