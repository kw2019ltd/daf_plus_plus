import 'package:daf_plus_plus/services/hive/progressBox.dart';
import 'package:daf_plus_plus/services/hive/settingsBox.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  ProgressBox progress = progressBox;
  SettingsBox settings = settingsBox;

  Future<void> initHive() async {
    await Hive.initFlutter();
  }
}

final HiveService hiveService = HiveService();
