import '../pubspec/internal_parts.dart';
import 'document.dart';
import 'line.dart';
import 'line_detached.dart';
import 'section.dart';

/// A section which is a single line with no children
/// but which can have comments.
class SectionSingleLine extends SectionImpl implements Section {
  SectionSingleLine.fromLine(super.sectionHeading) : super.fromLine() {
    key = sectionHeading.key;
  }

  SectionSingleLine.attach(
      PubSpec pubspec, Line lineBefore, this.key, String value)
      : super.fromLine(
            LineImpl.forInsertion(pubspec.document, '$key: $value')) {
    document.insertAfter(sectionHeading, lineBefore);
  }

  SectionSingleLine.append(Document document, this.key, String value)
      : super.missing(document, key) {
    document.append(LineDetached('$key: $value'));
  }

  SectionSingleLine.missing(Document document, this.key)
      : super.missing(document, key);

  @override
  late final String key;

  String get value => sectionHeading.value;

  set value(String value) {
    if (missing) {
      final detached = LineDetached('$key: $value');
      sectionHeading = document.append(detached);
      missing = false;
    } else {
      sectionHeading.value = value;
    }
  }
}

abstract class SingleLine {
  String get value;
}
