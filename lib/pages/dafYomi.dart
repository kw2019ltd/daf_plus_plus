import 'package:daf_plus_plus/widgets/home/dafYomiFab.dart';
import 'package:flutter/material.dart';

import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/widgets/shared/masechet/masechet.dart';
import 'package:daf_plus_plus/models/daf.dart';

class DafYomiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime today = dateConverterUtil.getToday();
    DafModel daf = dafsDatesStore.getDafByDate(today);

    return Scaffold(
          body: MasechetWidget(
        daf: daf,
        inList: false,
      ),
      floatingActionButton:
                DafYomiFabWidget(),
    );
  }
}
