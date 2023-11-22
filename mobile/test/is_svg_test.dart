import 'package:flutter_test/flutter_test.dart';
import 'package:src/utils/is_svg.dart';

void main() {
  test('isSvg should return true for SVG file', () {
    const svgUrl = 'image.svg';
    final result = isSvg(url: svgUrl);
    expect(result, isTrue);
  });

  test('isSvg should return false for non-SVG file', () {
    const imageUrl = 'image.png';
    final result = isSvg(url: imageUrl);
    expect(result, isFalse);
  });
}
