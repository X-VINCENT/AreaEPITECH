import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:src/utils/encode.dart';

void main() {
  test('encodeControllerMap should encode a map of TextEditingController', () {
    final controller1 = TextEditingController(text: 'Value1');
    final controller2 = TextEditingController(text: 'Value2');

    final controllerMap = {'field1': controller1, 'field2': controller2};

    final encodedJson = encodeControllerMap(controllerMap);

    expect(encodedJson, '{"field1":"Value1","field2":"Value2"}');
  });

  test('stringToIntIfNumeric should convert numeric strings to int', () {
    const numericString = '123';
    const nonNumericString = 'abc';

    final numericResult = stringToIntIfNumeric(numericString);
    final nonNumericResult = stringToIntIfNumeric(nonNumericString);

    expect(numericResult, 123);
    expect(nonNumericResult, isNull);
  });

  test(
      'convertMapToTextControllers should convert a map to TextEditingController',
      () {
    final input = {
      'intField': 42,
      'stringField': 'Hello',
    };

    final result = convertMapToTextControllers(input);

    expect(result['intField']?.text, '42');
    expect(result['stringField']?.text, 'Hello');
  });

  test('convertStringToMap should convert a JSON string to a map', () {
    const jsonString = '{"key1":"value1", "key2":42}';

    final resultMap = convertStringToMap(jsonString);

    expect(resultMap, {'key1': 'value1', 'key2': 42});
  });

  test(
      'convertTextControllersToMap should convert TextEditingController to a map',
      () {
    final controller1 = TextEditingController(text: '123');
    final controller2 = TextEditingController(text: 'Hello');

    final input = {'field1': controller1, 'field2': controller2};

    final result = convertTextControllersToMap(input);

    expect(result['field1'], 123);
    expect(result['field2'], 'Hello');
  });

  test('formatAction should format an action map correctly', () {
    final actionConfig = {
      'param1': TextEditingController(text: 'Value1'),
      'param2': TextEditingController(text: '42'),
    };

    final reactionConfig = {
      'param3': TextEditingController(text: 'Hello'),
      'param4': TextEditingController(text: '80'),
    };

    final result = formatAction(
      'ActionName',
      'Description',
      true,
      1,
      2,
      '60',
      actionConfig,
      reactionConfig,
    );

    expect(result, {
      'name': 'ActionName',
      'description': 'Description',
      'active': true,
      'refresh_delay': '60',
      'action_id': 1,
      'action_config': {
        'param1': 'Value1',
        'param2': 42,
      },
      'reaction_id': 2,
      'reaction_config': {
        'param3': 'Hello',
        'param4': 80,
      },
    });
  });
}
