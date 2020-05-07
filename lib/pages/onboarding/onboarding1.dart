import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/pages/home.dart';
import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/widgets/core/spacer.dart';
import 'package:flutter/material.dart';

import 'package:daf_plus_plus/pages/onboarding/onboarding2.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';

class Onboarding1Page extends StatelessWidget {
  _yesAndFill(BuildContext context) {
    hiveService.settings.setIsDafYomi(true);
    _fillIn();
    hiveService.settings.setHasOpened(true);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        ModalRoute.withName('/'));
  }

  _fillIn() {
    DafModel todaysDaf =
        dafsDatesStore.getDafByDate(dateConverterUtil.getToday());
    int mesechtIndex = MasechetsData.THE_MASECHETS[todaysDaf.masechetId].index;
    if (mesechtIndex > 0) {
      for (int index = 0; index < mesechtIndex; index++) {
        MasechetModel masechet = MasechetsData.THE_MASECHETS.values
            .firstWhere((MasechetModel masechet) => masechet.index == index);
        ProgressModel progress =
            ProgressModel(data: List.filled(masechet.numOfDafs, 1));
        progressAction.update(masechet.id, progress);
      }
    }
    MasechetModel currentMasechet =
        MasechetsData.THE_MASECHETS[todaysDaf.masechetId];
    ProgressModel progress =
        ProgressModel(data: List.filled(currentMasechet.numOfDafs, 0));
    for (int i = 0; i < todaysDaf.number; i++) {
      progress.data[i] = 1;
    }
    progressAction.update(currentMasechet.id, progress);
  }

  _justYes(BuildContext context) {
    hiveService.settings.setIsDafYomi(true);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => Onboarding2Page(),
      ),
    );
  }

  _no(BuildContext context) {
    hiveService.settings.setIsDafYomi(false);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => Onboarding2Page(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                          localizationUtil.translate(
                              "onboarding", "onboarding1_title"),
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        SpacerWidget(height: 24),
                        Text(
                          localizationUtil.translate(
                              "onboarding", "onboarding1_subtitle"),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SpacerWidget(height: 42),
          ListTile(
            title: ButtonWidget(
              text: localizationUtil.translate(
                  "onboarding", "learning_daf_in_sync"),
              subtext: localizationUtil.translate(
                  "onboarding", "learning_daf_in_sync_subtext"),
              buttonType: ButtonType.Outline,
              color: Theme.of(context).primaryColor,
              onPressed: () => _yesAndFill(context),
            ),
          ),
          SpacerWidget(height: 24),
          ListTile(
            title: ButtonWidget(
              text: localizationUtil.translate(
                  "onboarding", "learning_daf_alone"),
              buttonType: ButtonType.Outline,
              color: Theme.of(context).primaryColor,
              onPressed: () => _justYes(context),
            ),
          ),
          SpacerWidget(height: 24),
          ListTile(
            title: ButtonWidget(
              text:
                  localizationUtil.translate("onboarding", "not_learning_daf"),
              buttonType: ButtonType.Outline,
              color: Theme.of(context).primaryColor,
              onPressed: () => _no(context),
            ),
          ),
          SpacerWidget(height: 42),
        ],
      ),
    );
  }
}
