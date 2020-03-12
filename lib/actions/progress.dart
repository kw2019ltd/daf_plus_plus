import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/consts/firestore.dart';
import 'package:daf_plus_plus/models/Response.dart';
import 'package:daf_plus_plus/models/dafLocation.dart';
import 'package:daf_plus_plus/services/firestore/index.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/stores/actionCounter.dart';

class ProgressAction {
  Future<bool> backup() async {
    // TODO: make this all a batch action
    // TODO: return other a response model
    hiveService.settings.setLastUpdatedNow();
    Map<String, String> progress = hiveService.progress.getAllProgress();
    DafLocationModel lastDaf =
        hiveService.settings.getLastDaf() ?? DafLocationModel.fromString("0-0");
    DateTime lastUpdated = hiveService.settings.getLastUpdated();
    // TODO: could wait for both together
    await firestoreService.progress.setProgress(progress);
    await firestoreService.settings.updateSettings({
      FirestoreConsts.LAST_DAF: lastDaf.toString(),
      FirestoreConsts.LAST_UPDATED: lastUpdated,
    });
    return true;
  }

  Future<bool> restore() async {
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
    Map<String, String> progress = progressResponse.data.map(
        (String masechetId, dynamic progress) =>
            MapEntry(masechetId, progress));

    hiveService.settings.setLastDaf(
        DafLocationModel.fromString(settings[FirestoreConsts.LAST_DAF]));
    hiveService.settings
        .setLastUpdated(settings[FirestoreConsts.LAST_UPDATED].toDate());
    hiveService.progress.setAllProgress(progress);
    return true;
  }

  void update(String masechetId, String encodedProgress,
      [int incrementCounterBy = 1, bool checkCounter = true]) {
    actionCounterStore.increment(incrementCounterBy);
    hiveService.progress.setMasechetProgress(masechetId, encodedProgress);
    if (actionCounterStore.numberOfActions >=
        Consts.PROGRESS_BACKUP_THRESHOLD) {
      backup();
      actionCounterStore.clear();
    }
  }
}

final ProgressAction progressAction = ProgressAction();
