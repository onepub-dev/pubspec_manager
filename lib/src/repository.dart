part of 'internal_parts.dart';

class Repository implements SingleLine {
  Repository(this.url);
  Repository.missing() : url = '';

  String url;

  @override
  String get value => url;
}

class RepositoryAttached extends SectionSingleLine {
  RepositoryAttached._fromLine(Line line)
      : repository = Repository(line.value),
        super.fromLine(_key, line);

  RepositoryAttached.missing(Document document)
      : repository = Repository.missing(),
        super.missing(_key, document);

  @override
  // ignore: avoid_renaming_method_parameters
  RepositoryAttached set(String url) {
    repository.url = url;
    super.set(url);
    // ignore: avoid_returning_this
    return this;
  }

  String get url => repository.url;
  //final Document document;
  final Repository repository;

  static const String _key = 'repository';
}
