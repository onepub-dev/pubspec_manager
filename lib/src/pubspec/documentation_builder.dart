part of 'internal_parts.dart';

class DocumentationBuilder implements SingleLine {
  DocumentationBuilder(this.url);
  DocumentationBuilder.missing() : url = '';

  String url;

  @override
  String get value => url;
}
