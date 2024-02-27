part of 'internal_parts.dart';

class PublishTo extends SectionSingleLine {
  /// build PublishTo from an imported document line
  factory PublishTo._fromDocument(Document document) {
    final lineSection = document.getLineForKey(PublishTo.keyName);
    if (lineSection.missing) {
      return PublishTo.missing(document);
    } else {
      return PublishTo._(lineSection.headerLine);
    }
  }

  PublishTo._(super.line) : super.fromLine();

  PublishTo.missing(Document document) : super.missing(document, 0, keyName);

  String get url => super.value;

  PublishTo set(String url) {
    super.value = url;
    // ignore: avoid_returning_this
    return this;
  }

  static const String keyName = 'publish_to';
}
