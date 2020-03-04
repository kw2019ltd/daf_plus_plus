import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/services/hive/datesBox.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/gematriaConverter.dart';
import 'package:daf_plus_plus/utils/masechetConverter.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/dialog.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';
import 'package:flutter/material.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:intl/intl.dart';



class FirstUseDialogTwo extends StatelessWidget {

  _yes(BuildContext context) {
    // TODO: this is probably the worst code i have written in this project.
    // but this needs to change to a counter and not a bool...
//    String progress =
//    masechetConverterUtil.encode(this.progress.map((daf) => 1).toList());
//    hiveService.progress.setMasechetProgress(masechetId, progress);
    //  Navigator.pop(context);
//    Navigator.of(context).push(
//      TransparentRoute(
//
////        builder: (BuildContext context) => MasechetOptionsDialog(
////          masechetId: this.masechet.id,
////          progress: this.progress,
////        ),
//        builder: (BuildContext context) => FirstUseDialog(
//        ),
//
//      ),
//    );
    Navigator.pop(context);
  }

  _no(BuildContext context) {

  }

  String getYesterdaysDaf() {
    final now = DateTime.now();
    final yest = new DateTime(now.year, now.month, now.day - 1);
    Map<int, int> mD = datesBox.getDafForDate(new DateFormat("MMMM d, y").format(yest));
    String m = MasechetsData.THE_MASECHETS[mD.keys.first].name;
    String d =  gematriaConverter.toGematria(mD.values.first);
    return m + " " + d;
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      onTapBackground: () => Navigator.pop(context),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TitleWidget(
              title: "ברוכים הבאים לדף++",
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Text("כדי להתחיל, כמה שאלות קצרות:", textScaleFactor: 1.2),
                Padding(padding: EdgeInsets.only(top: 16), child:  Text("האם אתה אוחז בדף של היום?", textScaleFactor: 1, )),
                Text("הדף של אתמול היה: " +
                  getYesterdaysDaf(),
                  style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    textScaleFactor: 0.8),
                ListTile(
                  title: ButtonWidget(
                    text: "כן",
                    buttonType: ButtonType.Outline,
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _yes(context),
                  ),
                ),
                ListTile(
                  title: ButtonWidget(
                    text: "לא",
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