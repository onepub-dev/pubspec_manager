import 'dart:io';

String readFile(String pathToFile) => File(pathToFile).readAsStringSync();
