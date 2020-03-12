import 'package:flutter/cupertino.dart';

class MasechetModel {
  const MasechetModel({
    @required this.index,
    @required this.id,
    @required this.numOfDafs,
    @required this.sederId,
  });

  final int index;
  final String id;
  final int numOfDafs;
  final String sederId;
}
