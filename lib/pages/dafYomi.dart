import 'package:flutter/material.dart';

import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/widgets/shared/masechet/masechet.dart';
import 'package:daf_plus_plus/models/daf.dart';

class DafYomiPage extends StatelessWidget {
  Widget _openList(BuildContext context, DafModel daf) {
    return CustomScrollView(slivers: [MasechetWidget(
      masechetAndDaf: daf),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = dateConverterUtil.getToday();
    DafModel daf = dafsDatesStore.getDafByDate(today);

    return _openList(context, daf);
  }
}
