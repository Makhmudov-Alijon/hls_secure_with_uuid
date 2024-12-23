import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Prefs {
  // Private constructor
  Prefs._internal();

  // The single instance of the class
  static final Prefs _instance = Prefs._internal();

  // Public factory method to provide access to the singleton instance
  factory Prefs() {
    return _instance;
  }

  // The box name for storing key-value pairs
  static const String _boxName = 'shared_preferences_box';
  late Box _box;

  // Method to initialize the Hive box
  Future<void> init() async {
    final path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
    _box = await Hive.openBox(_boxName);
  }

  // Method to store a String value
  Future<void> putLocalHlsStatusName(int key, String value) async {
    await _box.put(key, value);
  }

  // Method to retrieve a String value
  String? getLocalHlsStatusNamee(int key) {
    return _box.get(key) as String?;
  }

  // Method to remove a value by its key
  Future<void> remove(String key) async {
    await _box.delete(key);
  }

  // Method to clear all values in the box
  Future<void> clear() async {
    await _box.clear();
  }

  // Method to check if a key exists in the box
  bool containsKey(String key) {
    return _box.containsKey(key);
  }
}
