import 'comments.dart';
import 'document.dart';
import 'line.dart';

/// Represent a section of a pubspec such as a dependency
/// an all lines attached to the dependency
/// Sections may be nested - e.g. The dependeny key is a
/// section as are each dependency under it.
// ignore: one_member_abstracts
abstract class Section {
  Section() : missing = false;
  Section.missing() : missing = true;

  /// An missing section doesn't appear in the pubspec.yaml
  bool missing;

  /// Returns the line that marks the start of a section.
  /// When determining the start of a section we ignore
  /// any comments and blank lines even though they are considered
  /// as part of the section.
  Line get line;

  /// returns the list of lines associated with this section
  /// including any comments immediately above the section.
  /// Comments may include blank lines and we return all
  /// lines upto the end of the prior segment.
  List<Line> get lines;

  /// List of comments associated with this section
  Comments get comments;

  /// The [Document] that contains this section.
  Document get document;

  /// The last line number used by this  section
  int get lastLineNo;
}
