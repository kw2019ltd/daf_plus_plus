import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/dialogs/firstUseDialogFillIn.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/pages/home.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/utils/gematriaConverter.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:flutter/material.dart';

class FirstUseDialogTwo extends StatefulWidget {
  @override
  _FirstUseDialogTwoState createState() => _FirstUseDialogTwoState();
}

class _FirstUseDialogTwoState extends State<FirstUseDialogTwo> {
  _yes(BuildContext context) {
    _fillIn();
    hiveService.settings.setHasOpened(true);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()));
  }

  _fillIn() {
    DafModel todaysDaf =
        dafsDatesStore.getDafByDate(dateConverterUtil.getToday());
    int mesechtIndex = MasechetsData.THE_MASECHETS[todaysDaf.masechetId].index;
    if (mesechtIndex > 0) {
      for (int index = 0; index < mesechtIndex; index++) {
        MasechetModel masechet = MasechetsData.THE_MASECHETS.values
            .firstWhere((MasechetModel masechet) => masechet.index == index);
        ProgressModel progress =
            ProgressModel(data: List.filled(masechet.numOfDafs, 1));
        progressAction.update(masechet.id, progress);
      }
    }
    MasechetModel currentMasechet = MasechetsData.THE_MASECHETS[todaysDaf.masechetId];
    ProgressModel progress =
        ProgressModel(data: List.filled(currentMasechet.numOfDafs, 0));
    for (int i = 0; i < todaysDaf.number; i++) {
      progress.data[i] = 1;
    }
    progressAction.update(currentMasechet.id, progress);
  }

  _no(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => FirstUseDialogFillIn(),
      ),
    );
  }

  String _getDafNumber(int daf) {
    if (localizationUtil.translate("calendar", "display_dapim_as_gematria"))
      return gematriaConverterUtil
          .toGematria((daf + Consts.FIST_DAF))
          .toString();
    return (daf + Consts.FIST_DAF).toString();
  }

  String _getYesterdaysDaf() {
    DateTime yesterday =
        dateConverterUtil.getToday().subtract(Duration(days: 1));
    DafModel yesterdaysDaf = dafsDatesStore.getDafByDate(yesterday);

    String masechet = localizationUtil.translate("shas", yesterdaysDaf.masechetId);
    String daf = _getDafNumber(yesterdaysDaf.number);
    return masechet + " " + daf;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(localizationUtil.translate("onbording", "welcome")),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    localizationUtil.translate("onbording", "daf_holding"),
                  )),
              Text(
                  localizationUtil.translate("onbording", "daf_yesterday") +
                      _getYesterdaysDaf(),
                  style: Theme.of(context).textTheme.caption),
              ListTile(
                title: ButtonWidget(
                  text: localizationUtil.translate("general", "yes"),
                  buttonType: ButtonType.Outline,
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _yes(context),
                ),
              ),
              ListTile(
                title: ButtonWidget(
                  text: localizationUtil.translate("general", "no"),
                  buttonType: ButtonType.Outline,
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _no(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
