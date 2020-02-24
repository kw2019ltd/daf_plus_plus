import 'package:flutter/cupertino.dart';

class MasechetModel {
  const MasechetModel({
    @required this.id,
    @required this.name,
    @required this.numOfDafs,
    @required this.sederId,
  });

  final int id;
  final String name;
  final int numOfDafs;
  final int sederId;
}