part of 'internal_parts.dart';

class IssueTrackerBuilder implements SingleLine {
  IssueTrackerBuilder(this.url);
  IssueTrackerBuilder.missing() : url = '';

  String url;

  @override
  String get value => url;
}
