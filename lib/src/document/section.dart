part of '../pubspec/internal_parts.dart';

/// A section that may have children and comments.
/// Represents a section of a pubspec such as a dependency
/// and all lines attached to the dependency
/// Sections may be nested - e.g. The dependency key is a
/// section as are each dependency under it.
abstract class Section {
  /// Indicates that this section does not
  /// exist in the pubspec.
  bool get missing;

  /// returns the list of lines associated with this section
  /// including any comments immediately above the section.
  /// Comments may include blank lines and we return all
  /// lines upto the end of the prior segment.
  List<Line> get lines;

  /// List of comments associated (prepended) with this section
  Comments get comments;
}
