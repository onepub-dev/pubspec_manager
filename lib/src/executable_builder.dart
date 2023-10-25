part of 'internal_parts.dart';

/// represents an executable
/// executable:
///   dcli: dcli_tool
class ExecutableBuilder {
  ExecutableBuilder({required this.name, this.script = ''});

  ExecutableBuilder.missing()
      : name = '',
        script = '';

  String name;
  String script;

  Executable _attach(PubSpec pubspec, int lineNo) =>
      Executable._attach(pubspec, lineNo, this);
}
