part of 'internal_parts.dart';

class PublishTo extends SectionSingleLine {
  /// build PublishTo from an imported document line
  factory PublishTo._fromDocument(Document document) {
    final lineSection = document.getLineForKey(PublishTo._key);
    if (lineSection.missing) {
      return PublishTo.missing(document);
    } else {
      return PublishTo._(lineSection.line);
    }
  }

  PublishTo._(super.line)
      : _url = line.value,
        super.fromLine();

  PublishTo.missing(Document document)
      : _url = '',
        super.missing(document, _key);

  String _url;

  PublishTo set(String url) {
    _url = url;
    super.value = url;
    // ignore: avoid_returning_this
    return this;
  }

  String get url => _url;

  static const String _key = 'publish_to';
}
