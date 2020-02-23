import 'package:daf_counter/consts/hive.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  Future<void> initHive() async {
    await Hive.initFlutter();
  }

  Future<void> openProgressBox() async {
    await Hive.openBox(HiveConsts.PROGRESS_BOX);
  }

  void closeProgressBox() {
    Hive.box(HiveConsts.PROGRESS_BOX).close();
  }

  String getGemaraProgress(int id) {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_BOX);
    String progress = progressBox.get(id);
    return progress;
  }

  void setGemaraProgress(int id, String progress) {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_BOX);
    progressBox.put(id, progress);
  }
}

final HiveService hiveService = HiveService();
