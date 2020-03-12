import 'dart:math';

import 'package:flutter/material.dart';

import 'package:daf_plus_plus/dialogs/masechetOptions.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/masechetConverter.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';

class MasechetWidget extends StatelessWidget {
  MasechetWidget({
    @required this.masechet,
    @required this.isExpanded,
    @required this.onChangeExpanded,
    @required this.progress,
  });

  final MasechetModel masechet;
  final bool isExpanded;
  final Function(bool) onChangeExpanded;
  final List<int> progress;

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
      onTap: _changeExpandedState,
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
              Transform.rotate(
                angle: this.isExpanded ? pi / 1 : 0,
                child: IconButton(
                  icon: Icon(Icons.keyboard_arrow_down),
                  onPressed: _changeExpandedState,
                ),
              ),
              Expanded(
                  child: Text(localizationUtil.translate('masechet') +
                      " " +
                      localizationUtil.translate(this.masechet.id))),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                    masechetConverterUtil.countDone(progress).toString() +
                        "/" +
                        progress.length.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
