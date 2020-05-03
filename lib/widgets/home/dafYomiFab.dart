import 'package:daf_plus_plus/utils/toast.dart';
import 'package:flutter/material.dart';

import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/utils/gematriaConverter.dart';
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
  double _scale;
  AnimationController _controller;

  DafModel _getTodaysDaf() {
    return dafsDatesStore.getDafByDate(dateConverterUtil.getToday());
  }

  void _displayInfo(BuildContext context) async {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => InfoDialogWidget(
          title: localizationUtil.translate("home", "daf_yomi_dialog_title"),
          text: localizationUtil.translate("home", "daf_yomi_dialog_text"),
          actionText: localizationUtil.translate("general", "confirm_button"),
        ),
      ),
    );
  }

  String _getDafNumber(dafNumber) {
    if (localizationUtil.translate("calendar", "display_dapim_as_gematria"))
      return gematriaConverterUtil
          .toGematria((dafNumber + Consts.FIST_DAF))
          .toString();
    return (dafNumber + Consts.FIST_DAF).toString();
  }

  void _learnedTodaysDaf() {
    DafModel todaysDaf = _getTodaysDaf();
    ProgressModel progress = progressAction.get(todaysDaf.masechetId);
    progress.data[todaysDaf.number] = 1; // TODO: really not ideal.
    progressAction.update(todaysDaf.masechetId, progress, 5);
    hiveService.settings.setLastDaf(todaysDaf);
    String masechet = localizationUtil.translate("general", "masechet") + " " + localizationUtil.translate("shas", todaysDaf.masechetId);
    String daf = localizationUtil.translate("general", "daf") + " " + _getDafNumber(todaysDaf.number);
    toastUtil
        .showInformation(masechet + " " + daf + " " + localizationUtil.translate("home", "daf_yomi_toast"));
  }

  void _onClick(BuildContext context, double width) async {
    _controller.reverse();
    bool isFirst = !hiveService.settings.getUsedFab();
    if (isFirst) {
      _displayInfo(context);
      hiveService.settings.setUsedFab(true);
    } else {
      _learnedTodaysDaf();
    }
  }

  Widget button() {
    return Container(
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
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
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.05,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      onTapDown: _onTapDown,
      child: Transform.scale(
        scale: _scale,
        child: button(),
      ),
    );
  }
}
