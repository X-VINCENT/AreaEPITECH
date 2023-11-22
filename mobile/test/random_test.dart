import 'package:flutter_test/flutter_test.dart';
import 'package:src/utils/random.dart';

void main() {
  test('randomElement should return a random element from the list', () {
    final list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    final element = randomElement(list);

    expect(list.contains(element), isTrue);
  });
}
