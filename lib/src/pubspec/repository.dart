part of 'internal_parts.dart';

class Repository extends SectionSingleLine {
  /// build Repository from an imported document line
  factory Repository._fromDocument(Document document) {
    final lineSection = document.getLineForKey(Repository.keyName);
    if (lineSection.missing) {
      return Repository.missing(document);
    } else {
      return Repository._(lineSection.headerLine);
    }
  }

  Repository._(super.line)
      : _url = line.value,
        super.fromLine();

  Repository.missing(Document document)
      : _url = '',
        super.missing(document, 0, keyName);

  String _url;

  Repository set(String url) {
    _url = url;
    super.value = url;
    // ignore: avoid_returning_this
    return this;
  }

  String get url => _url;

  static const String keyName = 'repository';
}
