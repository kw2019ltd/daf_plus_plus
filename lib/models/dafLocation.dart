class DafLocationModel {
  const DafLocationModel({
    this.masechetId = 0,
    this.dafIndex = 0,
  });

  final int masechetId;
  final int dafIndex;

  factory DafLocationModel.fromString(String dafLocation) {
    List<String> asList = dafLocation?.split("-") ?? [];
    if (asList.length < 2) return DafLocationModel();
    return DafLocationModel(
      masechetId: int.tryParse(asList[0]),
      dafIndex: int.tryParse(asList[1]),
    );
  }

  factory DafLocationModel.fromMap(Map<int, int> dafLocation) {
    if (dafLocation.length != 1) return DafLocationModel();
    return DafLocationModel(
      masechetId: dafLocation.keys.first,
      dafIndex: dafLocation.values.first,
    );
  }

  String toString() => masechetId.toString() + "-" + dafIndex.toString();
}
