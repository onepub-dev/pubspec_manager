import 'package:eric/eric.dart';

void main() {
  PubSpec.fromFile()
TODO: should we throw if the value isn't valid?
    ..version.value = '1.0.0-alpha.2'
    ..save();
}
