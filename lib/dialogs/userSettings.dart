import 'package:daf_counter/widgets/core/dialog.dart';
import 'package:daf_counter/widgets/core/title.dart';
import 'package:flutter/material.dart';

class UserSettingsDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      onTapBackground: () => Navigator.pop(context),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TitleWidget(
              title: "הגדרות משתמש",
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  title: Text("גבה לחשבון גוגל"),
                  trailing: FlatButton(
                    child: Text("התחבר"),
                    onPressed: () => {},
                  ),
                ),
                ListTile(
                  title: Text("התחל מההתחלה"),
                  trailing: FlatButton(
                    child: Text("אפס"),
                    onPressed: () => {},
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
