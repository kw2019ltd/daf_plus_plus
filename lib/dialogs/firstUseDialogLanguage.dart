import 'package:flutter/material.dart';

import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/dialogs/firstUseDialogOne.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';

class FirstUseDialogLanguage extends StatefulWidget {
  @override
  _FirstUseDialogLanguageState createState() => _FirstUseDialogLanguageState();
}

class _FirstUseDialogLanguageState extends State<FirstUseDialogLanguage> {
  List<String> _listOfLanguages = [""];

  void _changeLanguage(BuildContext context, String language) async {
    await localizationUtil.setPreferredLanguage(language);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => FirstUseDialogOne(),
      ),
    );
  }

  void _getLanguages() {
    List<String> listOfLanguages =
        Consts.LOCALES.map((Locale language) => language.languageCode).toList();
    setState(() {
      _listOfLanguages = listOfLanguages;
    });
  }

  @override
  void initState() {
    super.initState();
    _getLanguages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(localizationUtil.translate("onbording", "welcome")),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(height: 16),
            Text(localizationUtil.translate("onbording", "choose_language")),
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(16),
              children: _listOfLanguages
                  .map((language) => ListTile(
                        title: ButtonWidget(
                          text: localizationUtil.translate("settings", language),
                          buttonType: ButtonType.Outline,
                          color: Theme.of(context).primaryColor,
                          onPressed: () => _changeLanguage(context, language),
                        ),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
