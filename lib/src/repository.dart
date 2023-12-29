part of 'internal_parts.dart';

class Repository implements SingleLine {
  Repository(this.url);
  Repository.missing() : url = '';

  String url;

  @override
  String get value => url;
}

class RepositoryAttached extends SectionSingleLine {
  factory RepositoryAttached._fromLine(Document document) {
    final lineSection = document.getLineForKey(RepositoryAttached._key);
    if (lineSection.missing) {
      return RepositoryAttached.missing(document);
    } else {
      return RepositoryAttached._(lineSection.line);
    }
  }

  RepositoryAttached._(super.line)
      : repository = Repository(line.value),
        super.fromLine();

  RepositoryAttached.missing(Document document)
      : repository = Repository.missing(),
        super.missing(document, _key);

  final Repository repository;

  RepositoryAttached set(String url) {
    repository.url = url;
    super.value = url;
    // ignore: avoid_returning_this
    return this;
  }

  String get url => repository.url;

  static const String _key = 'repository';
}
