import 'package:flutter_test/flutter_test.dart';
import 'package:src/utils/search.dart';
void main() {
  test('findElementToService should return the correct value', () {
    final dataList = [
      {'id': 1, 'service_id': 101},
      {'id': 2, 'service_id': 102},
      {'id': 3, 'service_id': 103},
    ];
    final serviceList = [
      {'id': 101, 'key': 'key1'},
      {'id': 102, 'key': 'key2'},
      {'id': 103, 'key': 'key3'},
    ];
    final result = findElementToService(dataList, serviceList, 2, 'key');
    expect(result, 'key2');
  });

  test('collectLogos should return a list of logo URLs', () {
    final dataList = [
      {'service_id': 101},
      {'service_id': 102},
      {'service_id': 103},
    ];
    final serviceList = [
      {'id': 101, 'logo_url': 'logo1'},
      {'id': 102, 'logo_url': 'logo2'},
      {'id': 103, 'logo_url': 'logo3'},
    ];
    final result = collectLogos(dataList, serviceList);
    expect(result, ['logo1', 'logo2', 'logo3']);
  });

  test('extractUniqueServiceInfo should return unique service info', () {
    final dataList = [
      {'service_id': 101},
      {'service_id': 102},
      {'service_id': 101},
      {'service_id': 103},
    ];
    final serviceList = [
      {'id': 101, 'logo_url': 'logo1', 'name': 'Service 1', 'key': 'key1'},
      {'id': 102, 'logo_url': 'logo2', 'name': 'Service 2', 'key': 'key2'},
      {'id': 103, 'logo_url': 'logo3', 'name': 'Service 3', 'key': 'key3'},
    ];
    final result = extractUniqueServiceInfo(dataList, serviceList);
    expect(result, [
      {'service_id': 101, 'logo_url': 'logo1', 'name': 'Service 1', 'key': 'key1'},
      {'service_id': 102, 'logo_url': 'logo2', 'name': 'Service 2', 'key': 'key2'},
      {'service_id': 103, 'logo_url': 'logo3', 'name': 'Service 3', 'key': 'key3'},
    ]);
  });
}