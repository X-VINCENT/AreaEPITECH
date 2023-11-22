import 'package:flutter_test/flutter_test.dart';
import 'package:src/utils/string.dart';

void main() {
  test('capitalizeFirstLetter should capitalize the first letter', () {
    expect(capitalizeFirstLetter('word'), 'Word');
    expect(capitalizeFirstLetter('apple'), 'Apple');
    expect(capitalizeFirstLetter('orange'), 'Orange');
    expect(capitalizeFirstLetter(''), ''); // Empty string remains empty
  });

  test('addSpacesToCamelCase should add spaces to camel case strings', () {
    expect(addSpacesToCamelCase('camelCaseString'), 'camel Case String');
    expect(addSpacesToCamelCase('helloWorld'), 'hello World');
    expect(addSpacesToCamelCase('testString'), 'test String');
    expect(addSpacesToCamelCase('single'), 'single'); // No changes for non-camel case
    expect(addSpacesToCamelCase(''), ''); // Empty string remains empty
  });
}
