import 'dart:convert';

import 'package:flutter/services.dart';

class JsonLoader {
  static final JsonLoader _instance = JsonLoader._internal();
  factory JsonLoader() => _instance;
  JsonLoader._internal();

  Future<List<dynamic>> loadJsonList(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final dynamic json = jsonDecode(jsonString);
      if (json is List) return json.cast<Map<String, dynamic>>();
      throw Exception('Expected JSON array at $assetPath');
    } catch(e) {
      throw Exception('Failed to load $assetPath:: $e');
    }
  }
}