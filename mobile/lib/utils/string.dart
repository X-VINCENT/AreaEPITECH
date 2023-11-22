String capitalizeFirstLetter(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}

String addSpacesToCamelCase(String input) {
  if (input.isEmpty) {
    return input;
  }

  final result = StringBuffer(input[0]);

  for (int i = 1; i < input.length; i++) {
    final currentChar = input[i];
    final previousChar = input[i - 1];

    if (currentChar != currentChar.toLowerCase() &&
        previousChar != previousChar.toUpperCase()) {
      result.write(' ');
    }

    result.write(currentChar);
  }

  return result.toString();
}
