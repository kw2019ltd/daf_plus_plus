import 'package:flutter/material.dart';

import 'package:daf_plus_plus/dialogs/firstUseDialogTwo.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/dialog.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/dialogs/FirstUseDialogFillIn.dart';

class FirstUseDialogOne extends StatelessWidget {
  _yes(BuildContext context) {
    hiveService.settings.setIsDafYomi(true);
    // Navigator.pop(context);
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => FirstUseDialogTwo(),
      ),
    );
  }

  _no(BuildContext context) {
    hiveService.settings.setIsDafYomi(false);
    // Navigator.pop(context);
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => FirstUseDialogFillIn(),
      ),
    );
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
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      "האם אתה לומד את דף היומי?",
                      textScaleFactor: 1,
                    )),
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
