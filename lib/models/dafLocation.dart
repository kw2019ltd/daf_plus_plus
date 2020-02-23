class DafLocationModel {
  const DafLocationModel({
    this.gemaraId = 0,
    this.dafIndex = 0,
  });

  final int gemaraId;
  final int dafIndex;

  factory DafLocationModel.fromString(String dafLocation) {
    List<String> asList = dafLocation?.split("-") ?? [];
    print(asList);
    if (asList.length < 2) return DafLocationModel();
    return DafLocationModel(
      gemaraId: int.tryParse(asList[0]),
      dafIndex: int.tryParse(asList[1]),
    );
  }

  String toString() => gemaraId.toString() + "-" + dafIndex.toString();
}
