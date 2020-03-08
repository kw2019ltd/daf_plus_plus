import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/services/hive/datesBox.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/gematriaConverter.dart';
import 'package:daf_plus_plus/utils/masechetConverter.dart';
import 'package:daf_plus_plus/widgets/SimpleMesechetWidget.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/dialog.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';
import 'package:flutter/material.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:intl/intl.dart';



class FirstUseDialogFillIn extends StatefulWidget {

  @override
  _FirstUseDialogFillInState createState() => _FirstUseDialogFillInState();
}

class _FirstUseDialogFillInState extends State<FirstUseDialogFillIn> {
  List<bool> _progress = [];

  _yes(BuildContext context) {

    Navigator.pop(context);
    // TODO Set all daf done till current
  }

  _done(BuildContext context) {
//    _progress.forEach((element) {
//
//    })
    Navigator.pop(context);

  }

  @override
  void initState() {
    super.initState();
    setState(() {
      for (int i = 0; i < MasechetsData.THE_MASECHETS.length; i++) {
        _progress.add(false);
      }
    });
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
    return DialogWidget(
      onTapBackground: () => Navigator.pop(context),
      child: Center(
        child:
        Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Text("איזה מסכתות למדת כבר:", textScaleFactor: 1.2),
              ),
              Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: MasechetsData.THE_MASECHETS.length,
                    itemBuilder:
                        (context, dafIndex) => SimpleMesechetWidget(
                      name: MasechetsData.THE_MASECHETS[dafIndex].name,
                      checked: _progress[dafIndex],
                      onChange: (bool state) => _onClickDaf(dafIndex, state),
                    ),
                  )
              ),
              ListTile(
                title: ButtonWidget(
                  text: "הבא",
                  buttonType: ButtonType.Outline,
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _done(context),
                ),
              ),

            ]
        ),
      ),
    );
  }
}