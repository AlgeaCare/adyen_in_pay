import 'dart:math';

/// Generates a random string of a given length.
///
/// Uses alphanumeric characters (uppercase, lowercase, and digits).
String generateRandomString(int length) {
  final random = Random();
  // Define the character set.
  const availableChars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  // Generate a random string from the available characters.
  final randomString = List.generate(length,
      (index) => availableChars[random.nextInt(availableChars.length)]).join();

  return randomString;
}
