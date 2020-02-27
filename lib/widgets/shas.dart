import 'package:daf_counter/data/masechets.dart';
import 'package:daf_counter/data/seders.dart';
import 'package:daf_counter/models/masechet.dart';
import 'package:daf_counter/widgets/masechetCard.dart';
import 'package:daf_counter/widgets/core/title.dart';
import 'package:daf_counter/widgets/seder.dart';
import 'package:flutter/material.dart';

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

  Widget _title() {
    return TitleWidget(
      onTap: this.onActivate,
      title: "כל השס",
    );
  }

  Widget _openList() {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              TitleWidget(
                title: "כל השס",
                hasShadow: false,
              ),
              active
                  ? Expanded(
                      child: CustomScrollView(slivers: _generateList()),
                    )
                  : Container(),
            ],
          ),
          Positioned(top: 0, left: 0, right: 0, child: _title()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return active ? _openList() : _title();
  }
}
