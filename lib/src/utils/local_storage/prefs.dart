import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Box<dynamic>? _box;

class Prefs {
  Prefs._();

  static const String _boxName = 'shared_preferences_box';

  // Method to initialize the Hive box
  // static Future<void> init() async {
  //   _box = await Hive.openBox(_boxName);
  // }

  static Future<void> init() async {
    final path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
    _box = await Hive.openBox(_boxName);
  }

  // Method to store a String value
  static Future<void> putLocalHlsStatusName(String key, String value) async {
    if (_box == null) {
      await init();
    }

    await _box!.put(key, value);
  }

  // Method to retrieve a String value
  static Future<String?> getLocalHlsStatusNamee(String key) async {
    if (_box == null) {
      await init();
    }
    return _box!.get(key) as String?;
  }

  // Method to remove a value by its key
  static Future<void> remove(String key) async {
    if (_box == null) {
      await init();
    }
    await _box!.delete(key);
  }

  // Method to clear all values in the box
  static Future<void> clear() async {
    if (_box == null) {
      await init();
    }
    await _box!.clear();
  }

  // Method to check if a key exists in the box
  static bool containsKey(String key) {
    if (_box == null) {
      return false;
    }
    return _box!.containsKey(key);
  }
}
