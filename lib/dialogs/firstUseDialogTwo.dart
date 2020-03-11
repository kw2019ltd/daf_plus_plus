import 'package:daf_plus_plus/pages/home.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/services/hive/datesBox.dart';
import 'package:daf_plus_plus/utils/gematriaConverter.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/dialog.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';

class FirstUseDialogTwo extends StatelessWidget {
  _yes(BuildContext context) {
    hiveService.settings.setHasOpened(true);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    // TODO Set all daf done till current
  }

  _no(BuildContext context) {
    hiveService.settings.setHasOpened(true);
    MaterialPageRoute(builder: (BuildContext context) => HomePage());
  }

  String getYesterdaysDaf() {
    final now = DateTime.now();
    final yest = new DateTime(now.year, now.month, now.day - 1);
    Map<int, int> mD =
        datesBox.getDafForDate(new DateFormat("MMMM d, y").format(yest));
    String m = MasechetsData.THE_MASECHETS[mD.keys.first].name;
    String d = gematriaConverter.toGematria(mD.values.first + 1);
    return m + " " + d;
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
                      localizationUtil.translate("daf_holding", textScaleFactor: 1.2),
                      textScaleFactor: 1,
                    )),
                Text(
                    localizationUtil.translate("daf_yesterday") +
                        getYesterdaysDaf(),
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
