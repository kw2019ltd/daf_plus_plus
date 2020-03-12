import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:flutter/material.dart';

class SetDafYomiWidget extends StatefulWidget {
  @override
  _SetDafYomiWidgetState createState() => _SetDafYomiWidgetState();
}

class _SetDafYomiWidgetState extends State<SetDafYomiWidget> {
  bool _doesDafYomi = false;

  void _changeDafYomi(bool doesDaf) async {
    _doesDafYomi = doesDaf;
    hiveService.settings.setIsDafYomi(_doesDafYomi);
    setState(() {});
  }

  void _getDoesDaf() {
    _doesDafYomi = hiveService.settings.getIsDafYomi();
  }

  @override
  void initState() {
    super.initState();
    _getDoesDaf();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListTile(
        title: Text(localizationUtil.translate('do_you_daf')),
        trailing: Checkbox(
          value: _doesDafYomi,
          activeColor: Theme
              .of(context)
              .primaryColor,
          onChanged: _changeDafYomi,
        ),
      ),
    );
  }
}
