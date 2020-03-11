import 'package:daf_plus_plus/dialogs/firstUseDialogOne.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/dialog.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';
import 'package:flutter/material.dart';

class FirstUseDialogLanguage extends StatelessWidget {
  _heb(BuildContext context) async {
    await localizationUtil
        .setPreferredLanguage("he")
        .then((value) => _navForward(context));
  }

  _navForward(BuildContext context) {
    Navigator.pop(context);
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => FirstUseDialogOne(),
      ),
    );
  }

  _en(BuildContext context) async {
    await localizationUtil
        .setPreferredLanguage("en")
        .then((value) => _navForward(context));
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
                Text("תבחר שפה:", textScaleFactor: 1.2),
                ListTile(
                  title: ButtonWidget(
                    text: "עברית",
                    buttonType: ButtonType.Outline,
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _heb(context),
                  ),
                ),
                ListTile(
                  title: ButtonWidget(
                    text: "English",
                    buttonType: ButtonType.Outline,
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _en(context),
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
