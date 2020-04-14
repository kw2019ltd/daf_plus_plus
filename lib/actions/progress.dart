import 'package:daf_plus_plus/models/progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/stores/actionCounter.dart';
import 'package:daf_plus_plus/stores/progress.dart';

class ProgressAction {
  /// return the progress store object
  ProgressStore _getProgressStore(BuildContext context,
          [bool listen = false]) =>
      Provider.of<ProgressStore>(context, listen: listen);

  void update(BuildContext context, String masechetId, ProgressModel progress,
      [int incrementCounterBy = 1, bool checkCounter = true]) {
    ProgressStore progressStore = _getProgressStore(context);
    actionCounterStore.increment(incrementCounterBy);
    hiveService.progress.setProgress(masechetId, progress);
    progressStore.setProgress(masechetId, progress);
  }

  ProgressModel get(BuildContext context, String masechetId) {
    ProgressStore progressStore = _getProgressStore(context);
    return progressStore.getProgressMap[masechetId];
  }

  void localToStore(BuildContext context) {
    ProgressStore progressStore = _getProgressStore(context);
    Map<String, ProgressModel> progressMap =
        hiveService.progress.getProgressMap();
    progressStore.setProgressMap(progressMap);
  }
}

final ProgressAction progressAction = ProgressAction();
