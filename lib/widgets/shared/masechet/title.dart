import 'dart:math';

import 'package:daf_plus_plus/dialogs/masechetOptions.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:flutter/material.dart';

import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/utils/localization.dart';

class MasechetTitleWidget extends StatelessWidget {
  MasechetTitleWidget({
    @required this.masechet,
    @required this.progress,
    @required this.inList,
    @required this.isExpanded,
    @required this.onChangeExpanded,
  });

  final MasechetModel masechet;
  final ProgressModel progress;
  final bool inList;
  final bool isExpanded;
  final Function(bool) onChangeExpanded;

  void _changeExpandedState() {
    this.onChangeExpanded(!this.isExpanded);
  }

  void _openMasechetOptions(BuildContext context) {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => MasechetOptionsDialog(
          masechetId: this.masechet.id,
          progress: this.progress,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: inList ? _changeExpandedState : () {},
      onLongPress: () => _openMasechetOptions(context),
      child: Container(
        padding: const EdgeInsets.only(top: 16),
        margin: EdgeInsets.only(right: 8, left: 8, bottom: 8),
        color: Theme.of(context).canvasColor,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).accentColor,
          ),
          child: Row(
            children: <Widget>[
              inList ? Transform.rotate(
                angle: this.isExpanded ? pi / 1 : 0,
                child: IconButton(
                  icon: Icon(Icons.keyboard_arrow_down),
                  onPressed: _changeExpandedState,
                ),
              ) : Container(),
              Expanded(
                  child: Text(localizationUtil.translate("general", "masechet") +
                      " " +
                      localizationUtil.translate("shas", this.masechet.id))),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                    progress.countDone().toString() +
                        "/" +
                        progress.data.length.toString()
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
