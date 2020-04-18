import 'package:daf_plus_plus/models/progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/stores/actionCounter.dart';
import 'package:daf_plus_plus/stores/progress.dart';

class ProgressAction {

  BuildContext _progressContext;

  void setProgressContext(BuildContext progressContext) => _progressContext = progressContext;
  BuildContext getProgressContext() => _progressContext;

  /// return the progress store object
  ProgressStore _getProgressStore([bool listen = false]) =>
      Provider.of<ProgressStore>(_progressContext, listen: listen);

  void update(String masechetId, ProgressModel progress,
      [int incrementCounterBy = 1, bool checkCounter = true]) {
    ProgressStore progressStore = _getProgressStore();
    actionCounterStore.increment(incrementCounterBy);
    hiveService.progress.setProgress(masechetId, progress);
    progressStore.setProgress(masechetId, progress);
  }

  void updateAll(Map<String, ProgressModel> progressMap,
      [int incrementCounterBy = 1, bool checkCounter = true]) {
    ProgressStore progressStore = _getProgressStore();
    actionCounterStore.increment(incrementCounterBy);
    hiveService.progress.setProgressMap(progressMap);
    progressStore.setProgressMap(progressMap);
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
}

final ProgressAction progressAction = ProgressAction();
