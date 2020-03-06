import 'package:flutter/material.dart';

import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/dafLocation.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/widgets/shared/masechetCard.dart';
import 'package:daf_plus_plus/widgets/core/sectionHeader.dart';

class DafYomiPage extends StatelessWidget {
  Widget _openList(BuildContext context, MasechetModel resentMasechet,
      DafLocationModel reasentDafLocation) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SectionHeaderWidget(
              header: localizationUtil.translate('masechet') +
                  " " +
                  resentMasechet.name,
            ),
            MasechetCardWidget(
              masechet: resentMasechet,
              lastDafIndex: reasentDafLocation.dafIndex,
              hasTitle: false,
              listHeight: constraints.maxHeight,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DafLocationModel reasentDafLocation = hiveService.settings.getLastDaf();
    MasechetModel resentMasechet =
        MasechetsData.THE_MASECHETS[reasentDafLocation.masechetId];

    return _openList(context, resentMasechet, reasentDafLocation);
  }
}
