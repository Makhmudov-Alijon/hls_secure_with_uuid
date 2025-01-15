import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Prefs {
  Prefs._();

  static const String _boxName = 'shared_preferences_box';

  // Method to initialize the Hive box
  static late Box<dynamic> _box;

  static Future<void> init() async {
    final path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
    _box = await Hive.openBox<dynamic>(_boxName);
  }

  // Method to store a String value
  static Future<void> putLocalHlsStatusIndex(int key, int value) async {
    await _box.put(key, value);
  }

  // Method to retrieve a String value
  static int? getLocalHlsStatusIndex(int key) {
    return _box.get(key) as int?;
  }

  // Method to remove a value by its key
  static Future<void> remove(String key) async {
    await _box.delete(key);
  }

  // Method to clear all values in the box
  static Future<void> clear() async {
    await _box.clear();
  }

  // Method to check if a key exists in the box
  static bool containsKey(String key) {
    if (_box == null) {
      return false;
    }
    return _box.containsKey(key);
  }
}
