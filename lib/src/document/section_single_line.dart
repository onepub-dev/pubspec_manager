import '../internal_parts.dart';
import 'document.dart';
import 'line.dart';
import 'line_detached.dart';
import 'simple_section.dart';

/// A section which is a single line with no children
/// but which can have comments.
class SectionSingleLine extends SimpleSection {
  SectionSingleLine.fromLine(super._line) : super.fromLine() {
    key = line.key;
  }

  SectionSingleLine.attach(PubSpec pubspec, int lineNo, this.key, String value)
      : super.fromLine(Line.forInsertion(pubspec.document, '$key: $value')) {
    document.insert(line, lineNo);
  }

  SectionSingleLine.missing(Document document, this.key)
      : super.missing(document, key);

  void set(String value) {
    if (missing) {
      final detached = LineDetached('$key: $value');
      line = document.append(detached);
      missing = false;
    } else {
      line.value = value;
    }
  }

  @override
  late final String key;
}

abstract class SingleLine {
  String get value;
}
