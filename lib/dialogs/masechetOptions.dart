import 'package:daf_counter/consts/consts.dart';
import 'package:flutter/material.dart';

class MasechetOptionsDialog extends StatelessWidget {

  MasechetOptionsDialog({
    @required this.masechetName,
  });

  final String masechetName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("אפשרויות ל" + Consts.MASECHET_TITLE + " " + masechetName),
      content: Column(
        children: <Widget>[
        ],
      ),
    );
  }
}