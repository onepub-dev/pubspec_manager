part of 'internal_parts.dart';

class DocumentationBuilder implements SingleLine {
  DocumentationBuilder(this.url);
  DocumentationBuilder.missing() : url = '';

  String url;

  // DocumentationAttached attach(Pubspec pubspec, int lineNo) =>
  //     DocumentationAttached.attach(pubspec, lineNo, this);

  @override
  String get value => url;
}
