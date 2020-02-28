import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/dafLocation.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/widgets/masechetCard.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';
import 'package:flutter/material.dart';

class RecentWidget extends StatelessWidget {
  RecentWidget({
    @required this.active,
    @required this.onActivate,
  });

  final bool active;
  final Function onActivate;

  Widget _title(MasechetModel resentMasechet) {
    return TitleWidget(
      onTap: this.onActivate,
      title: Consts.REASENT_TITLE +
          " - " +
          Consts.MASECHET_TITLE +
          " " +
          resentMasechet.name,
    );
  }

  Widget _openList(
      MasechetModel resentMasechet, DafLocationModel reasentDafLocation) {
    return Expanded(
      child: Stack(
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
              this.active
                  ? Expanded(
                      child: CustomScrollView(
                        slivers: [
                          MasechetCardWidget(
                            masechet: resentMasechet,
                            lastDafIndex: reasentDafLocation.dafIndex,
                            hasTitle: false,
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
          Positioned(top: 0, left: 0, right: 0, child: _title(resentMasechet)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DafLocationModel reasentDafLocation = hiveService.settings.getLastDaf();
    MasechetModel resentMasechet =
        MasechetsData.THE_MASECHETS[reasentDafLocation.masechetId];

    return this.active
        ? _openList(resentMasechet, reasentDafLocation)
        : _title(resentMasechet);
  }
}
