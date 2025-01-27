import 'package:download_manager/src/utils/prefs/pref_keys.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

export 'pref_keys.dart';

class Prefs {
  Prefs._();

  static const String _boxName = 'shared_preferences_box';

  // Method to initialize the Hive box
  static Box<dynamic>? _box;

  static bool get initialized => _box != null;

  static Future<void> initt() async {
    final path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
    _box = await Hive.openBox<dynamic>(_boxName);
  }

  // Method to store a String value
  static Future<void> setString(String key, String value) async {
    await _box!.put(key, value);
  } // Method to store a String value

  static Future<String?> getString(String key) async {
    final result = await _box!.get(key);
    return result as String?;
  } // Method to store a String value

  // Method to store a String value
  static Future<void> putLocalHlsStatusIndex(int key, int value) async {
    await _box!.put(key, value);
  } // Method to store a String value

  static Future<void> setWaitingForNetwork(int id) async {
    await _box!.put(PrefKeys.waitingForNetworkDownloading, id);
  }

  // Method to retrieve a String value
  static int? getWaitingForNetworkDownloadingHlsId() {
    return _box!.get(PrefKeys.waitingForNetworkDownloading) as int?;
  } // Method to retrieve a String value

  static int? getLocalHlsStatusIndex(int key) {
    return _box!.get(key) as int?;
  }

  // Method to remove a value by its key
  static Future<void> remove(String key) async {
    await _box!.delete(key);
  }

  // Method to clear all values in the box
  static Future<void> clear() async {
    final docPath = await getString(PrefKeys.uuidOfDocPath);
    await _box!.clear();
    if (docPath != null) {
      await setString(PrefKeys.uuidOfDocPath, docPath);
    }
  }

  // Method to check if a key exists in the box
  static bool containsKey(String key) {
    if (_box == null) {
      return false;
    }
    return _box!.containsKey(key);
  }
}
