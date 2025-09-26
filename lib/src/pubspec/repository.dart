part of 'internal_parts.dart';

class Repository extends SectionSingleLine {
  String _url;

  static const keyName = 'repository';

  /// build Repository from an imported document line
  factory Repository._fromDocument(Document document) {
    final lineSection = document.getLineForKey(Repository.keyName);
    if (lineSection.missing) {
      return Repository.missing(document);
    } else {
      return Repository._(lineSection.headerLine);
    }
  }

  Repository._(super.headerLine)
      : _url = headerLine.value,
        super.fromLine();

  Repository.missing(Document document)
      : _url = '',
        super.missing(document, 0, keyName);

  Repository set(String url) {
    _url = url;
    super.value = url;
    return this;
  }

  String get url => _url;
}
