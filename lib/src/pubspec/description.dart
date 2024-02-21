part of 'internal_parts.dart';

class Description extends MultiLine {
  Description.fromLine(super.line) : super.fromLine();
  Description.missing(Document document) : super.missing(document, _key);

  Description.fromString(Document document, String description)
      : super.fromLine(document.append(LineDetached('$_key: $description')));

  static const String _key = 'description';
}
