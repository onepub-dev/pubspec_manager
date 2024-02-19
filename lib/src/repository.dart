part of 'internal_parts.dart';

class Repository extends SectionSingleLine {
  /// build Repository from an imported document line
  factory Repository._fromDocument(Document document) {
    final lineSection = document.getLineForKey(Repository._key);
    if (lineSection.missing) {
      return Repository.missing(document);
    } else {
      return Repository._(lineSection.line);
    }
  }

  Repository._(super.line)
      : _url = line.value,
        super.fromLine();

  Repository.missing(Document document)
      : _url = '',
        super.missing(document, _key);

  String _url;

  Repository set(String url) {
    _url = url;
    super.value = url;
    // ignore: avoid_returning_this
    return this;
  }

  String get url => _url;

  static const String _key = 'repository';
}
