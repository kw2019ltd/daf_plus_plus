import 'package:daf_counter/consts/consts.dart';
import 'package:daf_counter/data/masechets.dart';
import 'package:daf_counter/models/dafLocation.dart';
import 'package:daf_counter/models/masechet.dart';
import 'package:daf_counter/services/hive/index.dart';
import 'package:daf_counter/widgets/masechetCard.dart';
import 'package:daf_counter/widgets/core/title.dart';
import 'package:flutter/material.dart';

class RecentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DafLocationModel reasentDafLocation = hiveService.settings.getLastDaf();
    MasechetModel resentMasechet =
        MasechetsData.THE_MASECHETS[reasentDafLocation.masechetId];

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            TitleWidget(
              title: Consts.REASENT_TITLE +
                  " - " +
                  Consts.MASECHET_TITLE +
                  " " +
                  resentMasechet.name,
              hasShadow: false,
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  MasechetCardWidget(
                    masechet: resentMasechet,
                    lastDafIndex: reasentDafLocation.dafIndex,
                    hasTitle: false,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: TitleWidget(
            title: Consts.REASENT_TITLE +
                " - " +
                Consts.MASECHET_TITLE +
                " " +
                resentMasechet.name,
          ),
        ),
      ],
    );
  }
}
