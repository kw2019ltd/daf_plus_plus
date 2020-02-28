import 'package:daf_counter/actions/backup.dart';
import 'package:daf_counter/services/hive/index.dart';
import 'package:daf_counter/widgets/header.dart';
import 'package:daf_counter/widgets/recent.dart';
import 'package:daf_counter/widgets/shas.dart';
import 'package:flutter/material.dart';

enum Section { RECENT, SHAS }

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
    setState(() => _areBoxesOpen = true);
  }

  Future<bool> _exitApp() async {
    await backupAction.backupProgress();
    return Future.value(true);
  }

  void _loadApp() async {
    await _openBoxes();
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
