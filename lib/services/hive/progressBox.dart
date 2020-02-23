import 'package:daf_counter/consts/hive.dart';
import 'package:hive/hive.dart';

class ProgressBox {
  Future<void> open() async {
    await Hive.openBox(HiveConsts.PROGRESS_BOX);
  }

  void close() {
    Hive.box(HiveConsts.PROGRESS_BOX).close();
  }

  String getMasechetProgress(int id) {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_BOX);
    String progress = progressBox.get(id);
    return progress;
  }

  void setMasechetProgress(int id, String progress) {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_BOX);
    progressBox.put(id, progress);
  }
}

final ProgressBox progressBox = ProgressBox();
