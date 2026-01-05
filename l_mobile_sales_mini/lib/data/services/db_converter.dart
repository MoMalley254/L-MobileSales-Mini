import 'dart:convert';

class DbConverter {
  // Encodes any object/list to a JSON string for SQLite
  static String? encode(dynamic value) {
    if (value == null) return null;
    return jsonEncode(value);
  }

  // Decodes a JSON string back to a list/map
  static dynamic decode(String? value) {
    if (value == null) return null;
    return jsonDecode(value);
  }

  // Helper for Booleans (SQLite uses 0/1)
  static int boolToInt(bool value) => value ? 1 : 0;
  static bool intToBool(int value) => value == 1;
}