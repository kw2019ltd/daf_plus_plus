import 'package:flutter/material.dart';

import 'package:daf_plus_plus/dialogs/firstUseDialogFillIn.dart';
import 'package:daf_plus_plus/dialogs/firstUseDialogTwo.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';

class FirstUseDialogOne extends StatelessWidget {
  _yes(BuildContext context) {
    hiveService.settings.setIsDafYomi(true);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => FirstUseDialogTwo(),
      ),
    );
  }

  _no(BuildContext context) {
    hiveService.settings.setIsDafYomi(false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => FirstUseDialogFillIn(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(localizationUtil.translate("welcome")),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(height: 16),
            Text(localizationUtil.translate("a_few_questions")),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  localizationUtil.translate("do_you_daf"),
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
        ),
      ),
    );
  }
}
