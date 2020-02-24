import 'package:daf_counter/consts/consts.dart';
import 'package:daf_counter/services/hive/index.dart';
import 'package:daf_counter/widgets/recent.dart';
import 'package:daf_counter/widgets/shas.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _openBoxes() async {
    await hiveService.settings.open();
    await hiveService.progress.open();
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
      body: SafeArea(
        child: FutureBuilder(
          future: _openBoxes(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) return Text(snapshot.error.toString());
              return Column(
                children: <Widget>[
                  Container(
                    height: Consts.REACENT_HEIGHT,
                    child: RecentWidget(),
                  ),
                  Expanded(child: ShasWidget())
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
