part of 'internal_parts.dart';

class Documentation implements SingleLine {
  Documentation(this.url);
  Documentation.missing() : url = '';

  String url;

  // DocumentationAttached attach(Pubspec pubspec, int lineNo) =>
  //     DocumentationAttached.attach(pubspec, lineNo, this);

  @override
  String get value => url;
}
