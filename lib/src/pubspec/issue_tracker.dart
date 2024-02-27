part of 'internal_parts.dart';

class IssueTracker extends SectionSingleLine {
  factory IssueTracker._fromDocument(Document document) {
    final lineSection = document.getLineForKey(IssueTracker.keyName);
    if (lineSection.missing) {
      return IssueTracker.missing(document);
    } else {
      return IssueTracker._(lineSection.headerLine);
    }
  }

  IssueTracker._(super.line)
      : issueTracker = IssueTrackerBuilder(line.value),
        super.fromLine();

  IssueTracker.missing(Document document)
      : issueTracker = IssueTrackerBuilder.missing(),
        super.missing(document, 0, keyName);

  final IssueTrackerBuilder issueTracker;

  IssueTracker set(String url) {
    issueTracker.url = url;
    super.value = url;
    // ignore: avoid_returning_this
    return this;
  }

  String get url => issueTracker.url;

  static const String keyName = 'issue_tracker';
}
