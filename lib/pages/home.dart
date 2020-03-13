import 'package:flutter/material.dart';

import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/dialogs/FirstUseDialogLanguage.dart';
import 'package:daf_plus_plus/dialogs/userSettings.dart';
import 'package:daf_plus_plus/pages/allShas.dart';
import 'package:daf_plus_plus/pages/dafYomi.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/dafYomiFab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _areBoxesOpen = false;

  Future<void> _openBoxes() async {
    await hiveService.settings.open();
    await hiveService.progress.open();
    setState(() => _areBoxesOpen = true);
  }

  Future<bool> _exitApp() async {
    await progressAction.backup();
    return Future.value(true);
  }

  bool isFirstRun() {
    // uncomment for testing
    //hiveService.settings.setHasOpened(false);
    return !hiveService.settings.getHasOpened();
  }

  loadFirstRun() {
    localizationUtil
        .setPreferredLanguage(Localizations.localeOf(context).languageCode);
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => FirstUseDialogLanguage(),
      ),
    );
  }

  void _loadApp() async {
    await _openBoxes();
    if (isFirstRun()) {
      loadFirstRun();
    }
    progressAction.backup();
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
    Map<String, Widget> _tabs = {
      'daf_yomi': DafYomiPage(),
      'all_shas': AllShasPage(),
    };
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
                  leading: Container(),
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
                floatingActionButton: DafYomiFabWidget(),
                body: TabBarView(children: _tabs.values.toList()),
              )
            : Container(),
      ),
    );
  }
}
