part of 'internal_parts.dart';

class Homepage extends SectionSingleLine {
  /// build homepage from an imported document line
  factory Homepage._fromDocument(Document document) {
    final lineSection = document.getLineForKey(Homepage.keyName);
    if (lineSection.missing) {
      return Homepage.missing(document);
    } else {
      return Homepage._(lineSection.headerLine);
    }
  }

  Homepage._(super.line)
      : _url = line.value,
        super.fromLine();

  Homepage.missing(Document document)
      : _url = '',
        super.missing(document, 0, keyName);

  String _url;

  Homepage set(String url) {
    _url = url;
    super.value = url;
    // ignore: avoid_returning_this
    return this;
  }

  String get url => _url;

  static const String keyName = 'homepage';
}
