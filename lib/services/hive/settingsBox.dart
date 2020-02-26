import 'package:daf_counter/consts/hive.dart';
import 'package:daf_counter/models/dafLocation.dart';
import 'package:hive/hive.dart';

class SettingsBox {
  Future<void> open() async {
    await Hive.openBox(HiveConsts.SETTINGS_BOX);
  }

  void close() {
    Hive.box(HiveConsts.SETTINGS_BOX).close();
  }

  DafLocationModel getLastDaf() {
    Box settingsBox = Hive.box(HiveConsts.SETTINGS_BOX);
    String lastDaf = settingsBox.get(HiveConsts.LAST_DAF);
    return DafLocationModel.fromString(lastDaf);
  }

  void setLastDaf(DafLocationModel lastDaf) {
    Box settingsBox = Hive.box(HiveConsts.SETTINGS_BOX);
    settingsBox.put(HiveConsts.LAST_DAF, lastDaf.toString());
    setLastUpdatedNow();
  }

  DateTime getLastUpdated() {
    Box settingsBox = Hive.box(HiveConsts.SETTINGS_BOX);
    DateTime lastUpdated = settingsBox.get(HiveConsts.LAST_UPDATED);
    return lastUpdated;
  }

  void setLastUpdatedNow() {
    setLastUpdated(DateTime.now());
  }

  void setLastUpdated(DateTime lastUpdated) {
    Box settingsBox = Hive.box(HiveConsts.SETTINGS_BOX);
    settingsBox.put(HiveConsts.LAST_UPDATED, lastUpdated);
  }
}

final SettingsBox settingsBox = SettingsBox();
