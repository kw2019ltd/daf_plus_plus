import 'package:daf_plus_plus/consts/hive.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:hive/hive.dart';

class DatesBox {
  Future<void> open() async {
    await Hive.openBox(HiveConsts.DATES_BOX);
  }

  void close() {
    Hive.box(HiveConsts.DATES_BOX).close();
  }

  List<String> getMasechetDates(int id) {
    Box progressBox = Hive.box(HiveConsts.DATES_BOX);
    List<String> progress = progressBox.get(id);
    return progress;
  }

  void setMasechetDates(int id, List<String> progress) {
    Box datesBox = Hive.box(HiveConsts.DATES_BOX);
    datesBox.put(id, progress);
  }

  Map<int, List<String>> getAllDates() {
    Box dateBox = Hive.box(HiveConsts.DATES_BOX);
    Map<int, List<String>> allDates = {};
    MasechetsData.THE_MASECHETS.forEach((MasechetModel masechet) =>
        allDates[masechet.id] = dateBox.get(masechet.id));
    return allDates;
  }

  Map<int, int> getDafForDate(String date) {
    int m = 0;
    int d = 0;
    getAllDates().forEach((key, value) {
      if (value != null) {
        for (int i = 0; i < value.length; i++) {
          String element = value[i];
          if (element == date) {
            m = key;
            d = i;
          }
        }
      }
    });
    return {m: d};
  }
}

final DatesBox datesBox = DatesBox();
