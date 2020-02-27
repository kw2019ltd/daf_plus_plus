import 'package:daf_counter/actions/backup.dart';
import 'package:daf_counter/consts/consts.dart';
import 'package:daf_counter/services/hive/index.dart';
import 'package:daf_counter/widgets/header.dart';
import 'package:daf_counter/widgets/recent.dart';
import 'package:daf_counter/widgets/shas.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool areBoxesOpen = false;

  Future<void> _openBoxes() async {
    await hiveService.settings.open();
    await hiveService.progress.open();
    setState(() => areBoxesOpen = true);
  }

  Future<bool> _exitApp() async {
    await backupAction.backupProgress();
    return Future.value(true);
  }

  void _loadApp() async {
    await _openBoxes();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _exitApp,
        child: SafeArea(
          child: areBoxesOpen
              ? Column(
                  children: <Widget>[
                    HeaderWidget(),
                    Container(
                      height: Consts.REACENT_HEIGHT,
                      child: RecentWidget(),
                    ),
                    Expanded(child: ShasWidget())
                  ],
                )
              : Container(),
        ),
      ),
    );
  }
}
