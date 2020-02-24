import 'package:daf_counter/widgets/core/dialog.dart';
import 'package:daf_counter/widgets/core/title.dart';
import 'package:flutter/material.dart';

class MasechetOptionsDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      onTapBackground: () => Navigator.pop(context),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TitleWidget(
              title: "אפשרויות נוספות",
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
              ],
            )
          ],
        ),
      ),
    );
  }
}
