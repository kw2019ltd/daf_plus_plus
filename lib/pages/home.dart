import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/dialogs/firstUseDialogOne.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/actions/backup.dart';
import 'package:daf_plus_plus/dialogs/userSettings.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/pages/dafYomi.dart';
import 'package:daf_plus_plus/pages/allShas.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _areBoxesOpen = false;

  Map<String, Widget> _tabs = {
    'daf_yomi': DafYomiPage(),
    'all_shas': AllShasPage(),
  };

  void addDataToDB(int id, String json) {
    List datesList = jsonDecode(json) as List;
    hiveService.dates.setMasechetDates(
        id, datesList.map((e) => e['date'] as String).toList(growable: false));
  }

  Future<void> _openBoxes() async {
    await hiveService.settings.open();
    await hiveService.progress.open();
    await hiveService.dates.open();
    if (hiveService.dates.getAllDates()[0] == null) {
      MasechetsData.THE_MASECHETS.forEach((MasechetModel masechet) {
        if (masechet.id < 36 || masechet.id > 38) {
          DefaultAssetBundle.of(context)
              .loadString('assets/' + masechet.translatedName + '.json')
              .then((value) => addDataToDB(masechet.id, value));
        }
      });
    }
    setState(() => _areBoxesOpen = true);
  }

  Future<bool> _exitApp() async {
    await backupAction.backupProgress();
    return Future.value(true);
  }

  bool isFirstRun() {
    // uncomment for testing
    hiveService.settings.setHasOpened(false);
    return !hiveService.settings.getHasOpened();
  }

  loadFirstRun() {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => FirstUseDialogOne(),
      ),
    );
  }

  void _loadApp() async {
    await _openBoxes();
    if (isFirstRun()) {
      loadFirstRun();
    }

    backupAction.backupProgress();
  }

  @override
  void initState() {
    super.initState();
    _loadApp();
  }

  @override
  void dispose() {
    hiveService.settings.close();
    hiveService.progress.close();
    super.dispose();
  }

  void _openUserSettings(BuildContext context) {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => UserSettingsDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: _exitApp,
        child: _areBoxesOpen
            ? Scaffold(
                appBar: AppBar(
                  title: Text(
                    localizationUtil.translate('app_name'),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  centerTitle: true,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () => _openUserSettings(context),
                    ),
                  ],
                  bottom: TabBar(
                    tabs: _tabs.keys
                        .map((text) => Tab(
                              child: Text(
                                localizationUtil.translate(text),
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ))
                        .toList(),
                  ),
                ),
                body: TabBarView(children: _tabs.values.toList()),
              )
            : Container(),
      ),
    );
  }
}
