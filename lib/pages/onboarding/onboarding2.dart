import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/pages/home.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/widgets/shared/simpleMesechetWidget.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:flutter/material.dart';

class Onboarding2Page extends StatefulWidget {
  @override
  _Onboarding2PageState createState() => _Onboarding2PageState();
}

class _Onboarding2PageState extends State<Onboarding2Page> {
  List<bool> _progress = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _progress = List.filled(MasechetsData.THE_MASECHETS.length, false);
    });
  }

  _done() {
    for (int index = 0; index < _progress.length; index++) {
      if (_progress[index]) {
        MasechetModel masechet = MasechetsData.THE_MASECHETS.values
            .firstWhere((MasechetModel masechet) => masechet.index == index);
        ProgressModel progress =
            ProgressModel(data: List.filled(masechet.numOfDafs, 1));
        progressAction.update(masechet.id, progress);
      }
    }

    hiveService.settings.setHasOpened(true);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        ModalRoute.withName('/'));
  }

  void _onClickDaf(int masechetIndex, bool state) {
    _updateDafCount(masechetIndex, state);
  }

  void _updateDafCount(int masechetIndex, bool state) {
    setState(() {
      _progress[masechetIndex] = state;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<MasechetModel> masechetsList =
        MasechetsData.THE_MASECHETS.values.toList();
    return Scaffold(
      body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: "onboardingHero",
              child: Container(
                color: Theme.of(context).primaryColor,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 48, horizontal: 32),
                    child: Text(
                      localizationUtil.translate(
                          "onboarding", "choose_masechets"),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: masechetsList.length,
              itemBuilder: (context, dafIndex) => SimpleMesechetWidget(
                name: localizationUtil.translate(
                    "shas", masechetsList[dafIndex].id),
                checked: _progress[dafIndex],
                onChange: (bool state) => _onClickDaf(dafIndex, state),
              ),
            )),
            Container(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              child: ButtonWidget(
                text: localizationUtil.translate("general", "done"),
                buttonType: ButtonType.Outline,
                color: Theme.of(context).primaryColor,
                onPressed: _done,
              ),
            ),
          ]),
    );
  }
}
