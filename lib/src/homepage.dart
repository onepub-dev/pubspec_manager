part of 'internal_parts.dart';

// class Homepage {
//   Homepage({required this.url, this.comments = const <String>[]});
//   Homepage.missing()
//       : url = '',
//         comments = const <String>[];

//   final String url;
//   final List<String> comments;
// }

class Homepage extends SectionSingleLine {
  /// build homepage from an imported document line
  factory Homepage._fromLine(Document document) {
    final lineSection = document.getLineForKey(Homepage._key);
    if (lineSection.missing) {
      return Homepage.missing(document);
    } else {
      return Homepage._(lineSection.line);
    }
  }

  Homepage._(super.line)
      : _url = line.value,
        super.fromLine();

  Homepage.missing(Document document)
      : _url = '',
        super.missing(document, _key);

  String _url;

  Homepage set(String url) {
    _url = url;
    super.value = url;
    // ignore: avoid_returning_this
    return this;
  }

  String get url => _url;

  static const String _key = 'homepage';
}
