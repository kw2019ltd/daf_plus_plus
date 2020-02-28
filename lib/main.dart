import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:daf_plus_plus/pages/home.dart';

void main() async {
  await hiveService.initHive();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'דף++',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("he", "IL"),
      ],
      locale: Locale("he", "IL"),
      home: HomePage(),
      theme: themeUtil.getTheme(context),
    );
  }
}
