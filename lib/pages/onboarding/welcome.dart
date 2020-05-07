import 'package:daf_plus_plus/widgets/core/spacer.dart';
import 'package:flutter/material.dart';

import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/pages/onboarding/onboarding1.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';

class WelcomeOnboardingPage extends StatefulWidget {
  @override
  _WelcomeOnboardingPageState createState() => _WelcomeOnboardingPageState();
}

class _WelcomeOnboardingPageState extends State<WelcomeOnboardingPage> {
  List<String> _listOfLanguages = [""];

  void _changeLanguage(BuildContext context, String language) async {
    await localizationUtil.setPreferredLanguage(language);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => Onboarding1Page(),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: "onboardingHero",
              child: Container(
                color: Theme.of(context).primaryColor,
                child: SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 48, horizontal: 32),
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          localizationUtil.translate("onboarding", "welcome"),
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        SpacerWidget(height: 24),
                        Text(
                          localizationUtil.translate(
                              "onboarding", "welcome_subtitle"),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 48, horizontal: 32),
            children: _listOfLanguages
                .map((language) => ListTile(
                      title: ButtonWidget(
                        text: localizationUtil.translate(
                            "onboarding", "choose_" + language),
                        buttonType: ButtonType.Outline,
                        color: Theme.of(context).primaryColor,
                        onPressed: () => _changeLanguage(context, language),
                      ),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
