import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/widgets/core/dialog.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';
import 'package:daf_plus_plus/widgets/userSettings/SetDafYomiWidget.dart';
import 'package:daf_plus_plus/widgets/userSettings/deleteAll.dart';
import 'package:daf_plus_plus/widgets/userSettings/googleAccount.dart';
import 'package:daf_plus_plus/widgets/userSettings/setLanguage.dart';
import 'package:flutter/material.dart';

class UserSettingsDialog extends StatefulWidget {
  @override
  _UserSettingsDialogState createState() => _UserSettingsDialogState();
}

class _UserSettingsDialogState extends State<UserSettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      onTapBackground: () => Navigator.pop(context),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TitleWidget(
              title: localizationUtil.translate('settings_title'),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                GoogleAccountWidget(),
                SetLanguageWidget(),
                SetDafYomiWidget(),
                DeleteAllWidget(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
