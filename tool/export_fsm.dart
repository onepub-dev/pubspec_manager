import 'package:eric/src/document/yaml/yaml_string_parser.dart';

void main() async {
  final parser = await YamlStringParser.build();

  const pathTo = 'eric.smcat';
  parser.export(pathTo);
  print('Exported statemachine to $pathTo');
  print('Use FSM2 View to view the file');
}
