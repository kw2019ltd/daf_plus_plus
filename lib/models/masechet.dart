import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:flutter/material.dart';

class MasechetModel {
  const MasechetModel({
    @required this.index,
    @required this.id,
    @required this.numOfDafs,
    @required this.sederId,
    this.progress,
  });

  final int index;
  final String id;
  final int numOfDafs;
  final String sederId;
  final ProgressModel progress;

  factory MasechetModel.byMasechetId(String masechetId) =>
      MasechetsData.THE_MASECHETS[masechetId];
}
