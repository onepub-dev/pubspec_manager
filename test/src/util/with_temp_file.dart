import 'dart:io';

Future<R> withTempFile<R>(
  Future<R> Function(String tempFile) action,
) async {
  final dir = Directory.systemTemp.createTempSync();
  final temp = File('${dir.path}/temp')..createSync();

  R result;
  try {
    result = await action(temp.path);
  } finally {
    dir.deleteSync(recursive: true);
  }
  return result;
}
