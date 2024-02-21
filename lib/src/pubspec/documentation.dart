part of 'internal_parts.dart';

class Documentation extends SectionSingleLine {
  factory Documentation._fromDocument(Document document) {
    final lineSection = document.getLineForKey(Documentation._key);
    if (lineSection.missing) {
      return Documentation.missing(document);
    } else {
      return Documentation._(lineSection.sectionHeading);
    }
  }

  Documentation._(super.line)
      : builder = DocumentationBuilder(line.value),
        super.fromLine();

  Documentation.missing(Document document)
      : builder = DocumentationBuilder.missing(),
        super.missing(document, _key);

  final DocumentationBuilder builder;

  // ignore: avoid_renaming_method_parameters
  Documentation set(String url) {
    builder.url = url;
    super.value = url;

    // ignore: avoid_returning_this
    return this;
  }

  static const String _key = 'documentation';
}
