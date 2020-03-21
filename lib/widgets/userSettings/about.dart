import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutWidget extends StatelessWidget {
  _openSite() async {
    if (await canLaunch(Consts.PROJECT_URL)) await launch(Consts.PROJECT_URL);
    // TODO: show toast if cant open.
  }

  @override
  Widget build(BuildContext context) {
    List<String> text = localizationUtil
        .translate("about_us")
        .map<String>((dynamic text) => text.toString())
        .toList();

    return Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            Text(
              text[0],
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 8,
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: text[1],
                      style: Theme.of(context).textTheme.bodyText1),
                  TextSpan(
                      text: text[2],
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()..onTap = _openSite),
                  TextSpan(
                      text: text[3],
                      style: Theme.of(context).textTheme.bodyText1),
                ])),
          ],
        ));
  }
}
