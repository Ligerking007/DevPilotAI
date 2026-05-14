import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static const templatesBox = 'templates';
  static const historyBox = 'history';
  static const settingsBox = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    // These boxes are intentionally opened in one place before the app starts.
    // Settings currently use plain Hive storage; do not treat values there as
    // encrypted secrets.
    await Future.wait([
      Hive.openBox<Map>(templatesBox),
      Hive.openBox<Map>(historyBox),
      Hive.openBox<dynamic>(settingsBox),
    ]);
  }

  Box<Map> get templateBox => Hive.box<Map>(templatesBox);
  Box<Map> get history => Hive.box<Map>(historyBox);
  Box<dynamic> get settings => Hive.box<dynamic>(settingsBox);
}
