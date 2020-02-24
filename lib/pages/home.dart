import 'package:daf_counter/consts/consts.dart';
import 'package:daf_counter/widgets/recent.dart';
import 'package:daf_counter/widgets/shas.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: Consts.REACENT_HEIGHT,
              child: RecentWidget(),
            ),
            Expanded(child: ShasWidget())
          ],
        ),
      ),
    );
  }
}
