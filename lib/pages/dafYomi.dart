import 'package:flutter/material.dart';

import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/widgets/shared/masechetChildren.dart';
import 'package:daf_plus_plus/widgets/core/sectionHeader.dart';

class DafYomiPage extends StatelessWidget {
  Widget _openList(BuildContext context, MasechetModel masechet,
      DafModel daf) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeaderWidget(
          header: localizationUtil.translate('masechet') +
              " " +
              localizationUtil.translate(masechet.id),
        ),
        Expanded(
          child: MasechetChildrenWidget(
            masechet: masechet,
            lastDafIndex: daf.number,
            hasPadding:true,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = dateConverterUtil.getToday();
    DafModel daf = dafsDatesStore.getDafByDate(today);
    MasechetModel masechet = MasechetsData.THE_MASECHETS.firstWhere(
        (MasechetModel masechet) => masechet.id == daf.masechetId);

    return _openList(context, masechet, daf);
  }
}
