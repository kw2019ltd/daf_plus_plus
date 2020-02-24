import 'package:daf_counter/dialogs/userSettings.dart';
import 'package:daf_counter/utils/transparentRoute.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {

  void _openUserSettings(BuildContext context) {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => UserSettingsDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(width: 48),
          Text("מונה הדפים"),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => _openUserSettings(context),
          ),
        ],
      ),
    );
  }
}
