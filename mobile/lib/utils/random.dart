import 'dart:math';

T randomElement<T>(List<T> list) {
  final random = Random();
  final randomIndex = random.nextInt(list.length);
  return list[randomIndex];
}