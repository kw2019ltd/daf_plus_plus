import 'package:daf_counter/services/hive/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:daf_counter/pages/home.dart';

void main() async {
  await hiveService.initHive();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daf Counter',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("he", "IL"),
      ],
      locale: Locale("he", "IL"),
      home: HomePage(),
    );
  }
}
