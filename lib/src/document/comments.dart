// ignore_for_file: avoid_returning_this

import '../../eric.dart';
import 'document.dart';
import 'line.dart';
import 'line_type.dart';
import 'section.dart';

/// Used to hold the comments that prefix a section.
/// A comment section is all comments/blank lines that are above
/// a section upto where the proceeding section ends.
class Comments {
  Comments(this.section) {
    _lines = commentsAsLine();
  }

  Comments.empty(this.section) : _lines = <Line>[];

  /// Gets the set of comments that suffix the passed in [section]
  /// This will include any blank lines upto the end of the prior
  /// section.
  List<Line> commentsAsLine() {
    final document = section.document;

    final suffix = <Line>[];

    final lines = document.lines;

    /// there can be no comments if we are the first
    /// line of the pubspec.yaml
    if (section.line.lineNo == 1) {
      return suffix;
    }
    // search for comments starting from the prior line
    var lineNo = section.line.lineNo - 2;

    for (; lineNo > 0; lineNo--) {
      final line = lines[lineNo];
      final type = line.type;
      if (type == LineType.comment || type == LineType.blank) {
        suffix.insert(0, line);
      } else {
        break;
      }
    }
    return suffix;
  }

  // Comments.fromLine(this._pubspec, this.line) {
  //   name = line.key;
  // }

  /// The section these comments are attached to.
  Section section;

  /// All of the lines that make up this comment.
  late final List<Line> _lines;

  List<Line> get lines => _lines;

  /// the number of dependencies in this section
  int get length => _lines.length;

  /// Add [comment] to the PubSpec
  /// after the last line in this comment section.
  /// DO NOT prefix [comment] with a '#' as this
  /// method adds the '#'.
  Comments append(String comment, {bool attach = true}) {
    final document = section.line.document;
    final line = Line.forInsertion(document, '#$comment');
    _lines.add(line);

    if (attach) {
      document.insert(line, section.line.lineNo);
    }
    return this;
  }

  /// removes the comment a offset [index] in the list
  /// of comments for this section. [index] is zero based.
  /// If no comment exists at [index] then a [RangeError] is thrown.
  void removeAt(int index) {
    final document = section.document;
    if (index < 0) {
      throw OutOfBoundsException(
          section.line, 'Index must be >= 0 found $index}');
    }
    if (index > _lines.length) {
      throw OutOfBoundsException(
          section.line, 'Index must be < ${_lines.length} found $index}');
    }

    final line = _lines.removeAt(index);
    document.removeAll([line]);
  }

  void removeAll() {
    section.document.removeAll(_lines);
    _lines.removeRange(0, _lines.length);
  }
}

class DependencyNotFound extends PubSpecException {
  DependencyNotFound(Document super.document, super.message)
      : super.forDocument();
}

class OutOfBoundsException extends PubSpecException {
  OutOfBoundsException(super.line, super.message);
}

// List<String> commentsAsString(Section section) {
//   final lines = commentsAsLine(section);

//   return lines.map((line) => line.text).toList();
// }
