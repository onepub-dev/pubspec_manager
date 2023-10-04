part of 'internal_parts.dart';

// class Homepage {
//   Homepage({required this.url, this.comments = const <String>[]});
//   Homepage.missing()
//       : url = '',
//         comments = const <String>[];

//   final String url;
//   final List<String> comments;
// }

class HomepageAttached extends SectionSingleLine {
  /// build homepage from an imported document line
  factory HomepageAttached._fromLine(Document document) {
    final line = document.getLineForKey(HomepageAttached._key);
    if (line.missing) {
      return HomepageAttached.missing(document);
    } else {
      return HomepageAttached._(line);
    }
  }

  HomepageAttached._(Line line)
      : _url = line.value,
        super.fromLine(_key, line);

  HomepageAttached.missing(Document document)
      : _url = '',
        super.missing(_key, document);

  String _url;

  @override
  // ignore: avoid_renaming_method_parameters
  HomepageAttached set(String url) {
    _url = url;
    super.set(url);
    // ignore: avoid_returning_this
    return this;
  }

  String get url => _url;

  static const String _key = 'homepage';
}
