import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/models/masechet.dart';

class DafsDatesStore {
  // the _masechetsDates is a map of masechets ids
  // and a list of datetimes of the dafs in the masechet
  Map<String, List<DateTime>> _masechetsDates = {};

  void _getMasechetDates() {
    Map<String, List<DateTime>> masechetsDates = {};
    DateTime nextDate = DateTime.parse(Consts.DAF_YOMI_START_DATE);
    MasechetsData.THE_MASECHETS.values.forEach((MasechetModel masechet) {
      masechetsDates[masechet.id] = List.generate(
        masechet.numOfDafs,
        ((int dafIndex) =>
            DateTime(nextDate.year, nextDate.month, nextDate.day + dafIndex)),
      );
      nextDate = nextDate.add(Duration(days: masechet.numOfDafs));
    });
    _masechetsDates = masechetsDates;
  }

  void _checkLoadedDates() {
    if (_masechetsDates.length < 1) _getMasechetDates();
  }

  DateTime getDateByDaf(DafModel daf) {
    _checkLoadedDates();
    return _masechetsDates[daf.masechetId][daf.number];
  }

  DafModel getDafByDate(DateTime date) {
    _checkLoadedDates();
    // TODO: return error if no matching date
    DafModel dafLocation = DafModel();
    _masechetsDates.forEach((String masechetId, List<DateTime> dates) {
      if (dates.contains(date)) {
        dafLocation =
            DafModel(masechetId: masechetId, number: dates.indexOf(date));
      }
    });
    return dafLocation;
  }

  List<DateTime> getAllMasechetDates(String masechetId) {
    _checkLoadedDates();
    return _masechetsDates[masechetId];
  }
}

final DafsDatesStore dafsDatesStore = DafsDatesStore();
