import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';


void main() async {
  late Dio dio;
  late DioAdapter dioAdapter;
  Response<dynamic> response;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000'));
    dioAdapter = DioAdapter(dio: dio, matcher: const FullHttpRequestMatcher());
  });

  test('fetchData returns data from /api/area', () async {
    const areaRoute = '/api/area';

    final mockAreaResponse = {
      'success': true,
      'data': [],
      'message': 'Areas retrieved successfully.',
    };

    dioAdapter.onGet(
      areaRoute,
      (server) => server.reply(200, mockAreaResponse),
    );

    response = await dio.get(areaRoute);

    expect(response.statusCode, 200);
    expect(response.data, mockAreaResponse);
  });

  test('fetchData returns data from /api/services', () async {
    const servicesRoute = '/api/services';

    final mockServicesResponse = {
      'success': true,
      'data': [],
      'message': 'Services retrieved successfully.',
    };

    dioAdapter.onGet(
      servicesRoute,
      (server) => server.reply(200, mockServicesResponse),
    );

    response = await dio.get(servicesRoute);

    expect(response.statusCode, 200);
    expect(response.data, mockServicesResponse);
  });

  test('fetchData returns data from /api/area/logs', () async {
    const servicesRoute = '/api/services';

    final mockServicesResponse = {
      'success': true,
      'data': [],
      'message': 'Logs retrieved successfully.',
    };

    dioAdapter.onGet(
      servicesRoute,
      (server) => server.reply(200, mockServicesResponse),
    );

    response = await dio.get(servicesRoute);

    expect(response.statusCode, 200);
    expect(response.data, mockServicesResponse);
  });

    test('fetchData returns data from /api/reactions', () async {
    const areaRoute = '/api/reactions';

    final mockAreaResponse = {
      'success': true,
      'data': [],
      'message': 'Reactions retrieved successfully.',
    };

    dioAdapter.onGet(
      areaRoute,
      (server) => server.reply(200, mockAreaResponse),
    );

    response = await dio.get(areaRoute);

    expect(response.statusCode, 200);
    expect(response.data, mockAreaResponse);
  });

    test('fetchData returns data from /api/actions', () async {
    const areaRoute = '/api/actions';

    final mockAreaResponse = {
      'success': true,
      'data': [],
      'message': 'Actions retrieved successfully.',
    };

    dioAdapter.onGet(
      areaRoute,
      (server) => server.reply(200, mockAreaResponse),
    );

    response = await dio.get(areaRoute);

    expect(response.statusCode, 200);
    expect(response.data, mockAreaResponse);
  });
}