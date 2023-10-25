part of 'internal_parts.dart';

class IssueTracker extends SectionSingleLine {
  factory IssueTracker._fromLine(Document document) {
    final line = document.getLineForKey(IssueTracker._key);
    if (line.missing) {
      return IssueTracker.missing(document);
    } else {
      return IssueTracker._(line);
    }
  }

  IssueTracker._(super.line)
      : issueTracker = IssueTrackerBuilder(line.value),
        super.fromLine();

  IssueTracker.missing(Document document)
      : issueTracker = IssueTrackerBuilder.missing(),
        super.missing(document, _key);

  final IssueTrackerBuilder issueTracker;

  @override
  // ignore: avoid_renaming_method_parameters
  IssueTracker set(String url) {
    issueTracker.url = url;
    super.set(url);
    // ignore: avoid_returning_this
    return this;
  }

  String get url => issueTracker.url;

  static const String _key = 'issue_tracker';
}
