import 'package:flutter/material.dart';

import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/dafLocation.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/widgets/shared/masechetChildren.dart';
import 'package:daf_plus_plus/widgets/core/sectionHeader.dart';

class TodaysDafPage extends StatelessWidget {
  Widget _openList(BuildContext context, MasechetModel masechet,
      DafLocationModel dafLocation) {
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
            lastDafIndex: dafLocation.dafIndex,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DafLocationModel dafLocation = hiveService.settings.getLastDaf();
    MasechetModel masechet = MasechetsData.THE_MASECHETS.firstWhere(
        (MasechetModel masechet) => masechet.id == dafLocation.masechetId);

    return _openList(context, masechet, dafLocation);
  }
}
