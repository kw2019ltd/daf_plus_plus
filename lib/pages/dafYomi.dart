import 'package:daf_plus_plus/widgets/shared/masechet/masechet.dart';
import 'package:flutter/material.dart';

import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/models/masechet.dart';

class DafYomiPage extends StatelessWidget {
  Widget _openList(BuildContext context, MasechetModel masechet, DafModel daf) {
    return CustomScrollView(slivers: [MasechetWidget(
      masechetId: masechet.id,
    )]);
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = dateConverterUtil.getToday();
    DafModel daf = dafsDatesStore.getDafByDate(today);
    MasechetModel masechet = MasechetsData.THE_MASECHETS[daf.masechetId];

    return _openList(context, masechet, daf);
  }
}
