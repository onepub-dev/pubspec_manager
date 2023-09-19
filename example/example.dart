import 'package:eric/eric.dart';

void main() {
  PubSpec.fromFile()
    ..version.value = '1.0.0-alpha.2'
    ..save();
}
