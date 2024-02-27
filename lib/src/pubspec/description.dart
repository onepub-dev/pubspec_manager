part of 'internal_parts.dart';

class Description extends MultiLine {
  Description.fromLine(super.line) : super.fromLine();
  Description.missing(Document document) : super.missing(document, _key);

  Description.fromString(Document document, String description)
      : super.fromLine(document.append(LineDetached('$_key: $description')));

  factory Description._fromDocument(Document document) {
    final line = document.getLineForKey(_key);
    if (line.missing) {
      return Description.missing(document);
    }
    return Description.fromLine(line.headerLine);
  }

  static const String _key = 'description';
}
