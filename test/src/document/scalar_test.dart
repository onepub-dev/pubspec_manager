import 'package:eric/src/document/scalar.dart';
import 'package:test/test.dart';

void main() {
  test('scalar single quote', () async {
    const example =
        """
example: 'Several lines of text,\n
··containing ''single quotes''. Escapes (like \n) don''t do anything.\n
··\n
··Newlines can be added by leaving a blank line.\n
····Leading whitespace on lines is ignored.'\n
""";

    const result =
        """
Several lines of text, containing 'single quotes'. Escapes (like \n) don't do anything.\n
Newlines can be added by leaving a blank line. Leading whitespace on lines is ignored.
""";

    final scalar = Scalar()..processString(example);

    expect(scalar.value, equals(result));
  });
}
