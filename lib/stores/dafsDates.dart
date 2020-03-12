import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/dafLocation.dart';
import 'package:daf_plus_plus/models/masechet.dart';

class DafsDatesStore {
  // the _masechetsDates is a map of masechets ids
  // and the datetime of the first daf in the masechet
  Map<String, DateTime> _masechetsDates = {};

  void _getMasechetDates() {
    Map<String, DateTime> masechetsDates = {};
    DateTime nextDate = DateTime.parse(Consts.DAF_YOMI_START_DATE);
    MasechetsData.THE_MASECHETS.forEach((MasechetModel masechet) {
      masechetsDates[masechet.id] = nextDate;
      nextDate = nextDate.add(Duration(days: masechet.numOfDafs));
    });
    _masechetsDates = masechetsDates;
  }

  DateTime getDafDate(DafLocationModel daf) {
    if (_masechetsDates.length < 1) _getMasechetDates();
    return _masechetsDates[daf.masechetId].add(Duration(days: daf.dafIndex));
  }

  List<DateTime> getAllMasechetDates(String masechetId) {
    if (_masechetsDates.length < 1) _getMasechetDates();
    MasechetModel masechet = MasechetsData.THE_MASECHETS
        .firstWhere((MasechetModel masechet) => masechet.id == masechetId);
    return List.generate(
      masechet.numOfDafs,
      ((int dafIndex) =>
          _masechetsDates[masechetId].add(Duration(days: dafIndex))),
    );
  }
}

final DafsDatesStore dafsDatesStore = DafsDatesStore();
