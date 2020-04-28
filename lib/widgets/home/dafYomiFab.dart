import 'package:flutter/material.dart';

import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/core/infoDialog.dart';

// TODO: oh, wow, there is a lot that can be improved here:
// 1. what if the button is pressed, do we undo it, tell him something about it
// 2. what if he didn't press the button but the daf was learned, is it any differant?
// 3. should we tell him what daf it is today?
// 4. an undo option in the toast (maybe snackbar)
// 5. if not doing the daf yomi, dont show

class DafYomiFabWidget extends StatefulWidget {
  @override
  _DafYomiFabWidgetState createState() => _DafYomiFabWidgetState();
}

class _DafYomiFabWidgetState extends State<DafYomiFabWidget>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  double _fabHeight = 56;
  double _padding = 18;
  double _gap = 8;
  double _popupWidth = 0;

  double _popupPadding = 8;
  DafModel _getTodaysDaf() {
    return dafsDatesStore.getDafByDate(dateConverterUtil.getToday());
  }

  void _displayInfo(BuildContext context) async {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => InfoDialogWidget(
          title: localizationUtil.translate('plus_plus_dialog_title'),
          text: localizationUtil.translate('plus_plus_dialog_text'),
          actionText: localizationUtil.translate('confirm_button'),
        ),
      ),
    );
  }

  void _learnedTodaysDaf() {
    DafModel todaysDaf = _getTodaysDaf();
    ProgressModel progress = progressAction.get(todaysDaf.masechetId);
    progress.data[todaysDaf.number] = 1; // TODO: really not ideal.
    progressAction.update(todaysDaf.masechetId, progress);
    hiveService.settings.setLastDaf(todaysDaf);
  }

  void _onClick(BuildContext context, double width) async {
    if (!isOpened) {
      setState(() => isOpened = !isOpened);
      bool isFirst = !hiveService.settings.getUsedFab();
      if (isFirst) {
        _displayInfo(context);
        hiveService.settings.setUsedFab(true);
      } else {
        _learnedTodaysDaf();
        _open(width);
        await Future.delayed(Duration(seconds: 3));
        _close();
      }
      setState(() => isOpened = !isOpened);
    }
  }

  void _open(double width) {
    setState(() {
      _popupWidth = width - (_fabHeight + _gap + _padding * 2);
      _popupPadding = _fabHeight + _gap;
    });
  }

  void _close() {
    setState(() {
      _popupWidth = 0;
      _popupPadding = _gap;
    });
  }

  Widget popout() {
    return Transform(
      transform: Matrix4.translationValues(0, _fabHeight, 0),
      child: AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              spreadRadius: 0.0,
              offset: Offset(0, 10),
            )
          ],
        ),
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: EdgeInsets.only(left: _popupPadding),
        width: _popupWidth,
        height: _fabHeight,
        child: ClipRect(
          child: Center(child: Text(localizationUtil.translate('plus_plus_toast'))),
        ),
      ),
    );
  }

  Widget button() {
    return Container(
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        onPressed: () => _onClick(context, MediaQuery.of(context).size.width),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.check,
          color: Theme.of(context).textTheme.headline5.color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        popout(),
        button(),
      ],
    );
  }
}
