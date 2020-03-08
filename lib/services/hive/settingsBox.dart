import 'package:hive/hive.dart';

import 'package:daf_plus_plus/consts/hive.dart';
import 'package:daf_plus_plus/models/dafLocation.dart';

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

  String getPreferredLanguage() {
    Box settingsBox = Hive.box(HiveConsts.SETTINGS_BOX);
    String preferredLanguage = settingsBox.get(HiveConsts.PREFERRED_LANGUAGE);
    return preferredLanguage;
  }

  void setPreferredLanguage(String preferredLanguage) {
    Box settingsBox = Hive.box(HiveConsts.SETTINGS_BOX);
    settingsBox.put(HiveConsts.PREFERRED_LANGUAGE, preferredLanguage);
  }

  void setIsDafYomi(bool isdaf) {
    Box settingsBox = Hive.box(HiveConsts.SETTINGS_BOX);
    settingsBox.put(HiveConsts.IS_DAF_YOMI, isdaf);
  }

    void setHasOpened(bool hasOpened) {
      Box settingsBox = Hive.box(HiveConsts.SETTINGS_BOX);
          settingsBox.put(HiveConsts.HAS_OPENED, hasOpened);
    }

  bool getHasOpened() {
    Box settingsBox = Hive.box(HiveConsts.SETTINGS_BOX);
    return settingsBox.get(HiveConsts.HAS_OPENED) == null ? false : settingsBox.get(HiveConsts.HAS_OPENED);
  }



  }

final SettingsBox settingsBox = SettingsBox();
