import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:daf_plus_plus/dialogs/userSettings.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';

class AppBarWidget extends StatefulWidget with PreferredSizeWidget {
  AppBarWidget({this.tabs});

  final List<String> tabs;

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(92);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  double _plusPlusWidth = 0;

  void _openUserSettings(BuildContext context) {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => UserSettingsDialog(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() => _plusPlusWidth = 30);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SafeArea(
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             Image.asset(
                "assets/icon/daf-white-on-transperant.png",
                width: 30,
                height: 36,
              ),
            
            AnimatedContainer(
              duration: Duration(milliseconds: 150),
              width: _plusPlusWidth,
              height: 36,
              child: Image.asset(
                "assets/icon/pp-white-on-transperant.png",
                width: 36,
                height: 36,
                fit: BoxFit.fitHeight,
                alignment: Alignment.centerLeft,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      leading: Container(),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => _openUserSettings(context),
        ),
      ],
      bottom: TabBar(
        indicatorWeight: 3,
        indicatorColor: Theme.of(context).textTheme.headline5.color,
        tabs: widget.tabs
            .map((text) => Tab(
                  child: Text(
                    localizationUtil.translate("home", text),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ))
            .toList(),
      ),
    );
  }
}
