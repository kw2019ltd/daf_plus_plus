import 'package:flutter/material.dart';

import 'package:daf_plus_plus/widgets/userSettings/SetDafYomiWidget.dart';
import 'package:daf_plus_plus/widgets/userSettings/about.dart';
import 'package:daf_plus_plus/widgets/userSettings/deleteAll.dart';
import 'package:daf_plus_plus/widgets/userSettings/googleAccount.dart';
import 'package:daf_plus_plus/widgets/userSettings/setCalendar.dart';
import 'package:daf_plus_plus/widgets/userSettings/setLanguage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        GoogleAccountWidget(),
        SetLanguageWidget(),
        SetCalendarWidget(),
        SetDafYomiWidget(),
        DeleteAllWidget(),
        Divider(),
        AboutWidget(),
      ],
    );
  }
}
