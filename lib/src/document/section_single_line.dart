import '../internal_parts.dart';
import 'document.dart';
import 'line.dart';
import 'line_detached.dart';
import 'simple_section.dart';

class SectionSingleLine extends SimpleSection {
  SectionSingleLine.fromLine(this.key, super._line) : super.fromLine();

  SectionSingleLine.attach(this.key, PubSpec pubspec, int lineNo, String value)
      : super.fromLine(Line.forInsertion(pubspec.document, '$key: $value')) {
    document.insert(line, lineNo);
  }

  SectionSingleLine.missing(this.key, Document document)
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
  final String key;
}

abstract class SingleLine {
  String get value;
}
