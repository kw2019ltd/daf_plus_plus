import 'package:flutter/material.dart';

import 'package:daf_plus_plus/dialogs/userSettings.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';

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
      color: Theme.of(context).backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(width: 48),
          Text(localizationUtil.translate('app_name')),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => _openUserSettings(context),
          ),
        ],
      ),
    );
  }
}
