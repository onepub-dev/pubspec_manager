import 'dart:io';

/// replace \r\n with \n so tests work on windows and linux.
String readFile(String pathToFile) =>
    File(pathToFile).readAsStringSync().replaceAll('\r\n', '\n');
