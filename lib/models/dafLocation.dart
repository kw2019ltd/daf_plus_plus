import 'package:daf_plus_plus/consts/consts.dart';

class DafLocationModel {
  const DafLocationModel({
    this.masechetId = Consts.DEFAUT_MASECHET,
    this.dafIndex = Consts.DEFAUT_DAF,
  });

  final String masechetId;
  final int dafIndex;

  factory DafLocationModel.fromString(String dafLocation) {
    List<String> asList = dafLocation?.split(Consts.DATA_DIVIDER) ?? [];
    if (asList.length < 2) return DafLocationModel();
    return DafLocationModel(
      masechetId: asList[0],
      dafIndex: int.tryParse(asList[1]),
    );
  }

  factory DafLocationModel.fromMap(Map<String, int> dafLocation) {
    if (dafLocation.length != 1) return DafLocationModel();
    return DafLocationModel(
      masechetId: dafLocation.keys.first,
      dafIndex: dafLocation.values.first,
    );
  }

  factory DafLocationModel.empty() {
    return DafLocationModel(
      masechetId: Consts.DEFAUT_MASECHET,
      dafIndex: Consts.DEFAUT_DAF,
    );
  }

  String toString() =>
      masechetId.toString() + Consts.DATA_DIVIDER + dafIndex.toString();
}
