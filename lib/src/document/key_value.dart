import '../pubspec_exception.dart';
import 'line.dart';

class KeyValue {
  KeyValue._internal(this.key, this.value);

  KeyValue.fromLine(Line line) {
    var content = line.text;
    if (line.inlineComment != null) {
      content = content.substring(0, line.commentOffset);
    }
    final delimiter = content.indexOf(':');

    if (delimiter == -1) {
      throw PubSpecException(
          line, 'Line contained invalid key format - missing colon(:)');
    }
    key = content.substring(0, delimiter).trim();
    value = content.substring(delimiter + 1).trim();
  }

  KeyValue copy({String? key, String? value}) =>
      KeyValue._internal(key ?? this.key, value ?? this.value);

  late final String key;
  late final String value;
}
