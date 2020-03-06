import 'package:flutter/material.dart';

import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/data/seders.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/widgets/masechetCard.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';
import 'package:daf_plus_plus/widgets/seder.dart';

class ShasWidget extends StatelessWidget {
  ShasWidget({
    @required this.active,
    @required this.onActivate,
  });

  final bool active;
  final Function onActivate;

  List<Widget> _generateList() {
    int prevSederId = -1;
    List<Widget> list = [];
    MasechetsData.THE_MASECHETS.forEach((MasechetModel masechet) {
      if (prevSederId != masechet.sederId) {
        list.add(SederWidget(
          seder: SedersData.THE_SEDERS[masechet.sederId],
        ));
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

  Widget _title(BuildContext context) {
    return TitleWidget(
      onTap: this.onActivate,
      title: localizationUtil.translate('all_shas'),
    );
  }

  Widget _openList(BuildContext context) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              TitleWidget(
                title: localizationUtil.translate('all_shas'),
                hasShadow: false,
              ),
              active
                  ? Expanded(
                      child: CustomScrollView(slivers: _generateList()),
                    )
                  : Container(),
            ],
          ),
          Positioned(top: 0, left: 0, right: 0, child: _title(context)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return active ? _openList(context) : _title(context);
  }
}
