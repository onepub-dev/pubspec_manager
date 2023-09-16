import '../pub_spec_exception.dart';
import 'line.dart';

class KeyValue {
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
  late final String key;
  late final String value;
}
