part of 'internal_parts.dart';

class DocumentationAttached extends SectionSingleLine {
  factory DocumentationAttached._fromLine(Document document) {
    final line = document.getLineForKey(DocumentationAttached._key);
    if (line.missing) {
      return DocumentationAttached.missing(document);
    } else {
      return DocumentationAttached._(line);
    }
  }

  DocumentationAttached._(super.line)
      : documentation = Documentation(line.value),
        super.fromLine();

  DocumentationAttached.missing(Document document)
      : documentation = Documentation.missing(),
        super.missing(document, _key);

  final Documentation documentation;

  @override
  // ignore: avoid_renaming_method_parameters
  DocumentationAttached set(String url) {
    documentation.url = url;
    super.set(url);

    // ignore: avoid_returning_this
    return this;
  }

  static const String _key = 'documentation';
}
