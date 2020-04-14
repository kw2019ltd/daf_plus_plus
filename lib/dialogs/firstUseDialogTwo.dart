import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/dialogs/FirstUseDialogFillIn.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/pages/home.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/utils/gematriaConverter.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/dialog.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';
import 'package:flutter/material.dart';

class FirstUseDialogTwo extends StatelessWidget {
  _yes(BuildContext context) {
    _fillIn(context);
    hiveService.settings.setHasOpened(true);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()));
  }

  _fillIn(BuildContext context) {
    DafModel todaysDaf =
    dafsDatesStore.getDafByDate(dateConverterUtil.getToday());
    int mesechta = MasechetsData.THE_MASECHETS[todaysDaf.masechetId].index;
    if (mesechta > 0) {
      for (int i = 0; i < mesechta; i++) {
        MasechetModel masechet = MasechetsData.THE_MASECHETS[i];
        ProgressModel progress = ProgressModel(data: List.filled(masechet.numOfDafs, 1));
        progressAction.update(context, masechet.id, progress);
      }
    }
    MasechetModel currentMasechet = MasechetsData.THE_MASECHETS[mesechta];
    ProgressModel progress = ProgressModel(data: List.filled(currentMasechet.numOfDafs, 0));
    for (int i = 0; i < todaysDaf.number; i++) {
      progress.data[i] = 1;
    }
    progressAction.update(context, currentMasechet.id, progress);
  }

  _no(BuildContext context) {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => FirstUseDialogFillIn(),
      ),
    );
  }

  String _getDafNumber(int daf) {
    if (localizationUtil.translate('display_dapim_as_gematria'))
      return gematriaConverterUtil
          .toGematria((daf + Consts.FIST_DAF))
          .toString();
    return (daf + Consts.FIST_DAF).toString();
  }

  String _getYesterdaysDaf() {
    DateTime yesterday =
    dateConverterUtil.getToday().subtract(Duration(days: 1));
    DafModel yesterdaysDaf = dafsDatesStore.getDafByDate(yesterday);

    String masechet = localizationUtil.translate(yesterdaysDaf.masechetId);
    String daf = _getDafNumber(yesterdaysDaf.number);
    return masechet + " " + daf;
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      hasShadow: false,
      onTapBackground: () => Navigator.pop(context),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TitleWidget(
              title: localizationUtil.translate("welcome"),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      localizationUtil.translate("daf_holding"),
                      textScaleFactor: 1.2,
                    )),
                Text(
                    localizationUtil.translate("daf_yesterday") +
                        _getYesterdaysDaf(),
                    style: TextStyle(
                        color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    textScaleFactor: 0.8),
                ListTile(
                  title: ButtonWidget(
                    text: localizationUtil.translate("yes"),
                    buttonType: ButtonType.Outline,
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _yes(context),
                  ),
                ),
                ListTile(
                  title: ButtonWidget(
                    text: localizationUtil.translate("no"),
                    buttonType: ButtonType.Outline,
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _no(context),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
