import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/models/Response.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/services/firestore/index.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/stores/actionCounter.dart';
import 'package:daf_plus_plus/stores/progress.dart';

class ProgressAction {
  BuildContext _progressContext;

  void setProgressContext(BuildContext progressContext) =>
      _progressContext = progressContext;
  BuildContext getProgressContext() => _progressContext;

  /// return the progress store object
  ProgressStore _getProgressStore([bool listen = false]) =>
      Provider.of<ProgressStore>(_progressContext, listen: listen);

  void update(String masechetId, ProgressModel progress,
      [int incrementCounterBy = 1]) {
    ProgressStore progressStore = _getProgressStore();
    actionCounterStore.increment(incrementCounterBy);
    hiveService.progress.setProgress(masechetId, progress);
    progressStore.setProgress(masechetId, progress);
    _checkIfShouldBackup();
  }

  void updateAll(Map<String, ProgressModel> progressMap,
      [int incrementCounterBy = 5]) {
    ProgressStore progressStore = _getProgressStore();
    actionCounterStore.increment(incrementCounterBy);
    hiveService.progress.setProgressMap(progressMap);
    progressStore.setProgressMap(progressMap);
    _checkIfShouldBackup();
  }

  ProgressModel get(String masechetId) {
    ProgressStore progressStore = _getProgressStore();
    return progressStore.getProgressMap[masechetId];
  }

  void localToStore() {
    ProgressStore progressStore = _getProgressStore();
    Map<String, ProgressModel> progressMap =
        hiveService.progress.getProgressMap();
    progressStore.setProgressMap(progressMap);
  }

  Future<void> backup() async {
    Map<String, ProgressModel> progressMap =
        hiveService.progress.getProgressMap();
    ResponseModel backupResponse = await firestoreService.progress.setProgressMap(progressMap);
    if (backupResponse.isSuccessful()) {
      hiveService.settings.setLastBackupNow();
    }
  }

  Future<void> restore() async {
    ResponseModel progressResponse =
        await firestoreService.progress.getProgressMap();
    if (progressResponse.isSuccessful()) {
      hiveService.settings.setLastBackupNow();
      Map<String, ProgressModel> progressMap = progressResponse.data.map(
          (String masechetId, dynamic progress) => MapEntry(
              masechetId, ProgressModel.fromString(progress.toString())));
      hiveService.progress.setProgressMap(progressMap);
    }
  }

  void _checkIfShouldBackup() {
    if (actionCounterStore.numberOfActions >= Consts.PROGRESS_BACKUP_THRESHOLD) {
      backup();
      actionCounterStore.clear();
    }
  }
}

final ProgressAction progressAction = ProgressAction();
