import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/consts/firestore.dart';
import 'package:daf_plus_plus/models/Response.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/services/firestore/index.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/stores/actionCounter.dart';
import 'package:daf_plus_plus/stores/progress.dart';

class ProgressAction {
  /// return the progress store object
  ProgressStore _getProgressStore(BuildContext context,
          [bool listen = false]) =>
      Provider.of<ProgressStore>(context, listen: listen);

  // /// takes the current version form the local db and uploads to firestore
  // Future<bool> localToRomote() async {
  //   // TODO: make this all a batch action
  //   // TODO: return other a response model
  //   hiveService.settings.setLastUpdatedNow();
  //   Map<String, ProgressModel> progressMap =
  //       hiveService.progress.getProgressMap();
  //   DafModel lastDaf = hiveService.settings.getLastDaf() ?? DafModel.empty();
  //   DateTime lastUpdated = hiveService.settings.getLastUpdated();
  //   // TODO: could wait for both together
  //   await firestoreService.progress.setProgressMap(progressMap);
  //   await firestoreService.settings.updateSettings({
  //     FirestoreConsts.LAST_DAF: lastDaf.toString(),
  //     FirestoreConsts.LAST_UPDATED: lastUpdated,
  //   });
  //   return true;
  // }

  // /// gets to backup from firestore and puts it in the local storage
  // Future<bool> remoteToLocal() async {
  //   // TODO: return other a response model
  //   // TODO: make this all a batch action
  //   // TODO: could wait for both together
  //   ResponseModel settingsResponse =
  //       await firestoreService.settings.getSettings();
  //   if (!settingsResponse.isSuccessful()) return false;
  //   ResponseModel progressResponse =
  //       await firestoreService.progress.getProgressMap();
  //   if (!progressResponse.isSuccessful()) return false;
  //   Map<String, dynamic> settings = settingsResponse.data;
  //   Map<String, ProgressModel> progressMap = progressResponse.data.map(
  //       (String masechetId, dynamic progress) =>
  //           MapEntry(masechetId, ProgressModel.fromString(progress, masechetId)));
  //   hiveService.settings
  //       .setLastDaf(DafModel.fromString(settings[FirestoreConsts.LAST_DAF]));
  //   hiveService.settings
  //       .setLastUpdated(settings[FirestoreConsts.LAST_UPDATED].toDate());
  //   hiveService.progress.setProgressMap(progressMap);
  //   return true;
  // }

  // void storeToLocal() {}

  // void localToStore(BuildContext context) {
  //   ProgressStore progressStore = _getProgressStore(context);

  //   MasechetsData.THE_MASECHETS.forEach((MasechetModel masechet) {
  //     ProgressModel progress =
  //         hiveService.progress.getProgress(masechet.id);
  //     progressStore.setProgress(masechet.id, progress);
  //   });
  // }

  void update(BuildContext context, String masechetId, ProgressModel progress,
      [int incrementCounterBy = 1, bool checkCounter = true]) {
    ProgressStore progressStore = _getProgressStore(context);
    actionCounterStore.increment(incrementCounterBy);
    hiveService.progress.setProgress(masechetId, progress);
    progressStore.setProgress(masechetId, progress);

    // if (actionCounterStore.numberOfActions >=
    //     Consts.PROGRESS_BACKUP_THRESHOLD) {
    //   localToRomote();
    //   actionCounterStore.clear();
    // }
  }

  ProgressModel get(BuildContext context, String masechetId) {
    ProgressStore progressStore = _getProgressStore(context);
    return progressStore.getProgress(masechetId);
  }

  void localToStore(BuildContext context) {
    ProgressStore progressStore = _getProgressStore(context);
    Map<String, ProgressModel> progressMap =
        hiveService.progress.getProgressMap();
    progressStore.setProgressMap(progressMap);
  }
}

final ProgressAction progressAction = ProgressAction();
