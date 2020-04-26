import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/stores/progress.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/utils/theme.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/pages/splash.dart';

void main() async {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  await hiveService.initHive();
  await localizationUtil.init();
  runZoned(() {
    runApp(Provider<ProgressStore>(
        create: (_) => ProgressStore(), child: MyApp()));
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = localizationUtil.locale;

  _onLocaleChanged() {
    setState(() => _locale = localizationUtil.locale);
  }

  @override
  void initState() {
    super.initState();
    progressAction.setProgressContext(context);
    localizationUtil.onLocaleChangedCallback = _onLocaleChanged;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daf++',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: Consts.LOCALES,
      locale: _locale,
      home: SplashPage(),
      theme: themeUtil.getTheme(context),
    );
  }
}
