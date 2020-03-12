import 'package:daf_plus_plus/consts/hive.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:hive/hive.dart';

class ProgressBox {
  Future<void> open() async {
    await Hive.openBox(HiveConsts.PROGRESS_BOX);
  }

  void close() {
    Hive.box(HiveConsts.PROGRESS_BOX).close();
  }

  Stream<String> listenToProgress(String id) {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_BOX);
    // TODO: who said we didn't delete it and not update?
    return progressBox
        .watch(key: id)
        .map((BoxEvent progress) => progress.value);
  }

  String getMasechetProgress(String id) {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_BOX);
    String progress = progressBox.get(id);
    return progress;
  }

  void setMasechetProgress(String id, String progress) {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_BOX);
    progressBox.put(id, progress);
    hiveService.settings.setLastUpdatedNow();
  }

  void setAllProgress(Map<String, String> allProgress) {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_BOX);
    allProgress.forEach((String masechetId, String progress) {
      progressBox.put(masechetId, progress);
    });
    hiveService.settings.setLastUpdatedNow();
  }

  Map<String, String> getAllProgress() {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_BOX);
    Map<String, String> allProgress = {};
    MasechetsData.THE_MASECHETS.forEach((MasechetModel masechet) =>
        allProgress[masechet.id] = progressBox.get(masechet.id));
    return allProgress;
  }
}

final ProgressBox progressBox = ProgressBox();
