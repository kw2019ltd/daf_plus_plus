import 'package:flutter/material.dart';

import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/dafLocation.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/appLocalizations.dart';
import 'package:daf_plus_plus/widgets/masechetCard.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';

class RecentWidget extends StatelessWidget {
  RecentWidget({
    @required this.active,
    @required this.onActivate,
  });

  final bool active;
  final Function onActivate;

  Widget _title(BuildContext context, MasechetModel resentMasechet) {
    return TitleWidget(
      onTap: this.onActivate,
      title: AppLocalizations.of(context).translate('daf_yomi')
    );
  }

  Widget _openList(BuildContext context,
      MasechetModel resentMasechet, DafLocationModel reasentDafLocation) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              TitleWidget(
                title: AppLocalizations.of(context).translate('daf_yomi'),
                hasShadow: false,
              ),
              this.active
                  ? Expanded(
                      child: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return CustomScrollView(
                            shrinkWrap: true,
                            slivers: [
                              MasechetCardWidget(
                                masechet: resentMasechet,
                                lastDafIndex: reasentDafLocation.dafIndex,
                                hasTitle: false,
                                listHeight: constraints.maxHeight,
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
          Positioned(top: 0, left: 0, right: 0, child: _title(context, resentMasechet)),
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
        ? _openList(context, resentMasechet, reasentDafLocation)
        : _title(context, resentMasechet);
  }
}
