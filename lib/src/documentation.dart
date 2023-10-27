part of 'internal_parts.dart';

class Documentation extends SectionSingleLine {
  factory Documentation._fromLine(Document document) {
    final line = document.getLineForKey(Documentation._key);
    if (line.missing) {
      return Documentation.missing(document);
    } else {
      return Documentation._(line);
    }
  }

  Documentation._(super.line)
      : documentation = DocumentationBuilder(line.value),
        super.fromLine();

  Documentation.missing(Document document)
      : documentation = DocumentationBuilder.missing(),
        super.missing(document, _key);

  final DocumentationBuilder documentation;

  @override
  // ignore: avoid_renaming_method_parameters
  Documentation set(String url) {
    documentation.url = url;
    super.set(url);

    // ignore: avoid_returning_this
    return this;
  }

  static const String _key = 'documentation';
}
