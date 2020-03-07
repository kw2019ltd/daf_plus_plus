import 'dart:convert';

import 'package:daf_plus_plus/actions/backup.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/dialogs/firstUseDialogOne.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/header.dart';
import 'package:daf_plus_plus/widgets/recent.dart';
import 'package:daf_plus_plus/widgets/shas.dart';
import 'package:flutter/material.dart';

enum Section { RECENT, SHAS }
const String FIRST_RUN = 'firstRun';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _areBoxesOpen = false;
  Section _activeSection = Section.RECENT;

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

  void addDataToDB(int id, String json) {
    List datesList = jsonDecode(json) as List;
    hiveService.dates.setMasechetDates(id, datesList.map((e) => e['date'] as String)
        .toList(growable: false));
  }


  Future<bool> _exitApp() async {
    await backupAction.backupProgress();
    return Future.value(true);
  }

  void _loadApp() async {
    await _openBoxes();
    if (isFirstRun()) {
      loadFirstRun();
    }
    backupAction.backupProgress();
  }

  void _toggleActive() {
    Section newActive = Section.RECENT;
    if (_activeSection == newActive) newActive = Section.SHAS;
    setState(() => _activeSection = newActive);
  }

  @override
  void initState() {
    super.initState();
    _loadApp();
  }

  loadFirstRun() {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => FirstUseDialogOne(),
      ),
    );
  }

  bool isFirstRun()  {
    return !hiveService.settings.getHasOpened();
  }

  @override
  void dispose() {
    hiveService.settings.close();
    hiveService.progress.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _exitApp,
        child: SafeArea(
          child: _areBoxesOpen
              ? Column(
            children: <Widget>[
              HeaderWidget(),
              RecentWidget(
                active: _activeSection == Section.RECENT,
                onActivate: _toggleActive,
              ),
              // TODO: super ugelly divider...
              Container(height: 1),
              ShasWidget(
                active: _activeSection == Section.SHAS,
                onActivate: _toggleActive,
              ),
            ],
          )
              : Container(),
        ),
      ),
    );
  }
}
