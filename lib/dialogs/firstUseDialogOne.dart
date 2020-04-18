import 'package:daf_plus_plus/dialogs/firstUseDialogFillIn.dart';
import 'package:daf_plus_plus/dialogs/firstUseDialogTwo.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/dialog.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';
import 'package:flutter/material.dart';

class FirstUseDialogOne extends StatelessWidget {
  _yes(BuildContext context) {
    hiveService.settings.setIsDafYomi(true);
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => FirstUseDialogTwo(),
      ),
    );
  }

  _no(BuildContext context) {
    hiveService.settings.setIsDafYomi(false);
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => FirstUseDialogFillIn(),
      ),
    );
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
                Text(localizationUtil.translate("a_few_questions"),
                    textScaleFactor: 1.2),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      localizationUtil.translate("do_you_daf"),
                      textScaleFactor: 1,
                    )),
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
