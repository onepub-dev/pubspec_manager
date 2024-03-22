part of 'internal_parts.dart';

/// Describes the url of the package's issue tracker.
class IssueTracker implements Section {
  factory IssueTracker._fromDocument(Document document) {
    final lineSection = document.getLineForKey(IssueTracker.keyName);
    if (lineSection.missing) {
      return IssueTracker._missing(document);
    } else {
      return IssueTracker._(lineSection.headerLine);
    }
  }

  IssueTracker._(LineImpl line)
      : _url = line.value,
        _section = SectionSingleLine.fromLine(line);

  IssueTracker._missing(Document document)
      : _url = '',
        _section = SectionSingleLine.missing(document, 0, keyName);

  SectionSingleLine _section;

  String _url;

  /// Set the url of the package's issue tracker.
  IssueTracker set(String url) {
    _url = url;
    _section.value = url;
    // ignore: avoid_returning_this
    return this;
  }

  /// The url to the package's issue tracker.
  String get value => _url;

  static const String keyName = 'issue_tracker';

  @override
  Comments get comments => _section.comments;

  @override
  List<Line> get lines => _section.lines;

  @override
  bool get missing => _section.missing;
}
