import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _timersKey = 'timers_v1';
  static const _resourcesKey = 'resources_v1';
  static const _shieldsKey = 'shields_v1';
  static const _eventsKey = 'events_v1';

  Future<List<Map<String, dynamic>>> readList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> writeList(String key, List<Map<String, dynamic>> values) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(values));
  }

  Future<List<Map<String, dynamic>>> timers() => readList(_timersKey);
  Future<void> saveTimers(List<Map<String, dynamic>> v) => writeList(_timersKey, v);
  Future<List<Map<String, dynamic>>> resources() => readList(_resourcesKey);
  Future<void> saveResources(List<Map<String, dynamic>> v) => writeList(_resourcesKey, v);
  Future<List<Map<String, dynamic>>> shields() => readList(_shieldsKey);
  Future<void> saveShields(List<Map<String, dynamic>> v) => writeList(_shieldsKey, v);
  Future<List<Map<String, dynamic>>> events() => readList(_eventsKey);
  Future<void> saveEvents(List<Map<String, dynamic>> v) => writeList(_eventsKey, v);
}
