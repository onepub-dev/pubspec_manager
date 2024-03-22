part of 'internal_parts.dart';

/// Holds the url for the 'documentation' key.
class Documentation implements Section {
  factory Documentation._fromDocument(Document document) {
    final lineSection = document.getLineForKey(Documentation.keyName);
    if (lineSection.missing) {
      return Documentation._missing(document);
    } else {
      return Documentation._(lineSection.headerLine);
    }
  }

  Documentation._(LineImpl line)
      : _url = line.value,
        _section = SectionSingleLine.fromLine(line);

  Documentation._missing(Document document)
      : _url = '',
        _section = SectionSingleLine.missing(document, 0, keyName);

  /// Modifies the package's documentation url
  Documentation set(String url) {
    _url = url;
    _section.value = url;

    // ignore: avoid_returning_this
    return this;
  }

  /// Returns the url to the package's documetation.
  String get value => _url;

  SectionSingleLine _section;

  /// Url to the location of the packages documentation
  String _url;

  /// List of comments associated (prepended) with this section
  @override
  Comments get comments => _section.comments;

  /// returns the list of lines associated with this section
  /// including any comments immediately above the section.
  /// Comments may include blank lines and we return all
  /// lines upto the end of the prior segment.
  @override
  List<Line> get lines => _section.lines;

  @override
  bool get missing => _section.missing;

  static const String keyName = 'documentation';
}
