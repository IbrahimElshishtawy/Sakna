import 'package:hive_flutter/hive_flutter.dart';

class LocalDatabase {
  static const String _boxName = 'khidmaBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Box get _box => Hive.box(_boxName);

  static Future<void> saveData(String key, dynamic value) async {
    await _box.put(key, value);
  }

  static dynamic getData(String key) {
    return _box.get(key);
  }

  static Future<void> removeData(String key) async {
    await _box.delete(key);
  }

  static Future<void> clearAll() async {
    await _box.clear();
  }
}
