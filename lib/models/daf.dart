import 'package:daf_plus_plus/consts/consts.dart';

class DafModel {
  const DafModel({
    this.masechetId = Consts.DEFAUT_MASECHET,
    this.number = Consts.DEFAUT_DAF,
  });

  final String masechetId;
  final int number;

  factory DafModel.fromString(String dafLocation) {
    List<String> asList = dafLocation?.split(Consts.DATA_DIVIDER) ?? [];
    if (asList.length < 2) return DafModel();
    return DafModel(
      masechetId: asList[0],
      number: int.tryParse(asList[1]),
    );
  }

  factory DafModel.fromMap(Map<String, int> dafLocation) {
    if (dafLocation.length != 1) return DafModel();
    return DafModel(
      masechetId: dafLocation.keys.first,
      number: dafLocation.values.first,
    );
  }

  factory DafModel.empty() {
    return DafModel(
      masechetId: Consts.DEFAUT_MASECHET,
      number: Consts.DEFAUT_DAF,
    );
  }

  String toString() =>
      masechetId.toString() + Consts.DATA_DIVIDER + number.toString();
}
