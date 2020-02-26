import 'package:daf_counter/consts/consts.dart';
import 'package:daf_counter/dialogs/masechetOptions.dart';
import 'package:daf_counter/models/masechet.dart';
import 'package:daf_counter/utils/masechetConverter.dart';
import 'package:daf_counter/utils/transparentRoute.dart';
import 'package:flutter/material.dart';
import 'dart:math';

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
                  child:
                      Text(Consts.MASECHET_TITLE + " " + this.masechet.name)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                    masechetConverterUtil.countDone(progress).toString() +
                        "/" +
                        progress.length.toString()),
              ),
              // CircularProgressIndicator(
              //   value: masechetConverterUtil.toPercent(progress),
              //   strokeWidth: 3,
              //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
