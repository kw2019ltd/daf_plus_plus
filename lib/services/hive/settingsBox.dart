import 'package:daf_plus_plus/consts/hive.dart';
import 'package:daf_plus_plus/models/dafLocation.dart';
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

  bool getHasOpened() {
    Box settingsBox = Hive.box(HiveConsts.SETTINGS_BOX);
    return settingsBox.get(HiveConsts.HAS_OPENED) == null ? false : settingsBox.get(HiveConsts.HAS_OPENED);
  }

  void setHasOpened(bool hasOpened) {
    Box settingsBox = Hive.box(HiveConsts.SETTINGS_BOX);
    settingsBox.put(HiveConsts.HAS_OPENED, hasOpened);
  }

  bool getIsDafYomi() {
    Box settingsBox = Hive.box(HiveConsts.SETTINGS_BOX);
    settingsBox.get(HiveConsts.IS_DAF_YOMI);
  }

  void setIsDafYomi(bool isdaf) {
    Box settingsBox = Hive.box(HiveConsts.SETTINGS_BOX);
    settingsBox.put(HiveConsts.IS_DAF_YOMI, isdaf);
  }

}

final SettingsBox settingsBox = SettingsBox();
