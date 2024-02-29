// import 'package:pubspec_manager/src/document/scalar.dart';
// import 'package:test/test.dart';

// const word = 'simple';
// const sentence = 'a sentance goes here';

// const twolines = '''
// a sentance goes here
// and a second one here''';

// const singleQuote = r"""
// Several lines of text,
//   containing ''single quotes''. Escapes (like \n) don''t do anything.
  
//   Newlines can be added by leaving a blank line.
//     Leading whitespace on lines are ignored.""";

// const result = r"""
// Several lines of text, containing 'single quotes'. Escapes (like \n) don't do anything.
// Newlines can be added by leaving a blank line. Leading whitespace on lines are ignored.""";

// void main() {
//   group('plain flow', () {
//     test('scalar word', () async {
//       final scalar = Scalar();
//       await scalar.processString(word);
//       final value = scalar.value;

//       expect(value, equals(word));
//     });

//     test('scalar sentence', () async {
//       final scalar = Scalar();
//       await scalar.processString(sentence);
//       final value = scalar.value;

//       expect(value, equals(sentence));
//     });

//     test('scalar twolines', () async {
//       final scalar = Scalar();
//       await scalar.processString(twolines);
//       final value = scalar.value;

//       expect(value, equals(twolines.replaceAll(r'\n', ' ')));
//     });
//   });

//   group('single quote', () {
//     test('word', () async {
//       const singleQuoteWord = """'$word'""";

//       final scalar = Scalar();
//       await scalar.processString(singleQuoteWord);
//       final value = scalar.value;

//       expect(value, equals(word));
//     });

//     test('sentence', () async {
//       const input = """'$sentence'""";

//       final scalar = Scalar();
//       await scalar.processString(input);
//       final value = scalar.value;

//       expect(value, equals(sentence));
//     });

//     test('twolines', () async {
//       const input = """'$twolines'""";

//       final scalar = Scalar();
//       await scalar.processString(input);
//       final value = scalar.value;

//       expect(value, equals(twolines.replaceAll('\n', ' ')));
//     });
//     test('scalar single quote', () async {
//       final scalar = Scalar();
//       await scalar.processString("""
// '$singleQuote'
// """);
//       final value = scalar.value;

//       expect(value, equals(result));
//     });
//   });
// }
