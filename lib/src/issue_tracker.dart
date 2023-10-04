part of 'internal_parts.dart';

class IssueTracker implements SingleLine {
  IssueTracker(this.url);
  IssueTracker.missing() : url = '';

  String url;

  @override
  String get value => url;
}

class IssueTrackerAttached extends SectionSingleLine {
  factory IssueTrackerAttached._fromLine(Document document) {
    final line = document.getLineForKey(IssueTrackerAttached._key);
    if (line.missing) {
      return IssueTrackerAttached.missing(document);
    } else {
      return IssueTrackerAttached._(line);
    }
  }

  IssueTrackerAttached._(Line line)
      : issueTracker = IssueTracker(line.value),
        super.fromLine(_key, line);

  IssueTrackerAttached.missing(Document document)
      : issueTracker = IssueTracker.missing(),
        super.missing(_key, document);

  final IssueTracker issueTracker;

  @override
  // ignore: avoid_renaming_method_parameters
  IssueTrackerAttached set(String url) {
    issueTracker.url = url;
    super.set(url);
    // ignore: avoid_returning_this
    return this;
  }

  String get url => issueTracker.url;

  static const String _key = 'issue_tracker';
}
