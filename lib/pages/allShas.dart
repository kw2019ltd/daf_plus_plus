import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/data/seders.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/widgets/shared/masechetCard.dart';
import 'package:daf_plus_plus/widgets/core/sectionHeader.dart';

class AllShasPage extends StatelessWidget {
  List<Widget> _generateList() {
    int prevSederId = -1;
    List<Widget> list = [];
    MasechetsData.THE_MASECHETS.forEach((MasechetModel masechet) {
      if (prevSederId != masechet.sederId) {
        list.add(
          SliverStickyHeader(
            sticky: false,
            header: SectionHeaderWidget(
              header: localizationUtil.translate('seder') +
                  " " +
                  localizationUtil.translate(SedersData.THE_SEDERS[masechet.sederId].translatedName),
            ),
          ),
        );
        prevSederId = masechet.sederId;
      }
      list.add(
        MasechetCardWidget(
          masechet: masechet,
        ),
      );
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: _generateList());
  }
}
