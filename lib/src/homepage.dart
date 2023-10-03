part of 'internal_parts.dart';

class Homepage implements SingleLine {
  Homepage(this.url);
  Homepage.missing() : url = '';

  String url;

  @override
  String get value => url;
}

class HomepageAttached extends SectionSingleLine {
  // HomepageAttached._attach(Pubspec pubspec, int lineNo,
  // this.Homepage)
  //     : super.attach(_key, pubspec, lineNo, Homepage);

  HomepageAttached._fromLine(Line line)
      : homepage = Homepage(line.value),
        super.fromLine(_key, line);

  HomepageAttached.missing(Document document)
      : homepage = Homepage.missing(),
        super.missing(_key, document);

  @override
  // ignore: avoid_renaming_method_parameters
  HomepageAttached set(String url) {
    homepage.url = url;
    super.set(url);
    // ignore: avoid_returning_this
    return this;
  }

  String get url => homepage.url;
  //final Document document;
  final Homepage homepage;

  static const String _key = 'homepage';
}
