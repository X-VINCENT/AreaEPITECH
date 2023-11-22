import 'package:flutter_test/flutter_test.dart';
import 'package:src/utils/create_templates.dart';

void main() {
  test('getAvailableService returns a list of available services', () {
    final userMap = {'google_id': 'user123'};
    final services = [
      {'key': 'google', 'is_oauth': true},
      {'key': 'microsoft', 'is_oauth': false},
      {'key': 'github', 'is_oauth': true},
    ];

    final result = getAvailableService(userMap, services);

    expect(result, [
      {'key': 'google', 'is_oauth': true},
      {'key': 'microsoft', 'is_oauth': false},
    ]);
  });

  test('getAvailableService handles empty userMap', () {
    Map<String, dynamic> userMap = {};
    final services = [
      {'key': 'google', 'is_oauth': true},
      {'key': 'newsapi', 'is_oauth': false},
      {'key': 'github', 'is_oauth': true},
    ];

    final result = getAvailableService(userMap, services);

    expect(result, [
      {'key': 'newsapi', 'is_oauth': false},
    ]);
  });
}
