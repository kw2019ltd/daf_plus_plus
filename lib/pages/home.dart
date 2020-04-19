import 'package:daf_plus_plus/widgets/home/appBar.dart';
import 'package:flutter/material.dart';
import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/dialogs/firstUseDialogLanguage.dart';
import 'package:daf_plus_plus/pages/allShas.dart';
import 'package:daf_plus_plus/pages/dafYomi.dart';
import 'package:daf_plus_plus/pages/todaysDaf.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/home/dafYomiFab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _areBoxesOpen = false;
  bool _isDafYomi = true;
  Map<String, Widget> _tabs = {};

  Future<void> _loadProgress() async {
    await hiveService.settings.open();
    await hiveService.progress.open();
    setState(() => _areBoxesOpen = true);
    progressAction.backup();
  }

  Future<bool> _exitApp() async {
    return Future.value(true);
  }

  bool isFirstRun() {
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
    await _loadProgress();
    if (isFirstRun()) {
      loadFirstRun();
    }
    _listenToIsDafYomiUpdate();
    progressAction.localToStore();
  }

  void _listenToIsDafYomiUpdate() {
    bool isDafYomi = hiveService.settings.getIsDafYomi();
    _updateIsDafYomi(isDafYomi);
    hiveService.settings.listenToIsDafYomi().listen((bool isDafYomi) {
      _updateIsDafYomi(isDafYomi);
    });
  }

  void _updateIsDafYomi(isDafYomi) {
    Map<String, Widget> tabs = {};
    if (isDafYomi)
      tabs['daf_yomi'] = DafYomiPage();
    else
      tabs['todays_daf'] = TodaysDafPage();
    tabs['all_shas'] = AllShasPage();
    setState(() {
      _isDafYomi = isDafYomi;
      _tabs = tabs;
    });
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: WillPopScope(
        onWillPop: _exitApp,
        child: _areBoxesOpen
            ? Scaffold(
                appBar: AppBarWidget(tabs: _tabs.keys.toList()),
                floatingActionButton: _isDafYomi ? DafYomiFabWidget() : Container(),
                body: TabBarView(children: _tabs.values.toList()),
              )
            : Container(),
      ),
    );
  }
}
