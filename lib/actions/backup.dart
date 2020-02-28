import 'package:daf_plus_plus/consts/firestore.dart';
import 'package:daf_plus_plus/models/Response.dart';
import 'package:daf_plus_plus/models/dafLocation.dart';
import 'package:daf_plus_plus/services/firestore/index.dart';
import 'package:daf_plus_plus/services/hive/index.dart';

class BackupAction {

  Future<bool> backupProgress() async {
    // TODO: make this all a batch action
    // TODO: return other a response model
    hiveService.settings.setLastUpdatedNow();
    Map<int, String> progress = hiveService.progress.getAllProgress();
    DafLocationModel lastDaf = hiveService.settings.getLastDaf();
    DateTime lastUpdated = hiveService.settings.getLastUpdated();
    // TODO: could wait for both together
    await firestoreService.progress.setProgress(progress);
    await firestoreService.settings.updateSettings({
      FirestoreConsts.LAST_DAF: lastDaf.toString(),
      FirestoreConsts.LAST_UPDATED: lastUpdated,
    });
    return true;
  }

  Future<bool> restoreProgress() async {
    // TODO: return other a response model
    // TODO: make this all a batch action
    // TODO: could wait for both together
    ResponseModel settingsResponse =
        await firestoreService.settings.getSettings();
    if (!settingsResponse.isSuccessful()) return false;
    ResponseModel progressResponse =
        await firestoreService.progress.getProgress();
    if (!progressResponse.isSuccessful()) return false;
    Map<String, dynamic> settings = settingsResponse.data;
    Map<int, String> progress = progressResponse.data.map(
        (dynamic masechet, dynamic progress) =>
            MapEntry(int.parse(masechet), progress.toString()));

    hiveService.settings.setLastDaf(
        DafLocationModel.fromString(settings[FirestoreConsts.LAST_DAF]));
    hiveService.settings
        .setLastUpdated(settings[FirestoreConsts.LAST_UPDATED].toDate());
    hiveService.progress.setAllProgress(progress);
    return true;
  }
}

final BackupAction backupAction = BackupAction();
