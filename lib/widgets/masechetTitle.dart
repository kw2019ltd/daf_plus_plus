import 'package:daf_counter/consts/consts.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MasechetTitleWidget extends StatelessWidget {

  MasechetTitleWidget({
    @required this.masechetName,
    @required this.isExpanded,
    @required this.onChangeExpanded,
    @required this.progressInPecent,
  });

  final String masechetName;
  final bool isExpanded;
  final Function(bool) onChangeExpanded;
  final double progressInPecent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.blue,
      ),
      child: Row(
        children: <Widget>[
          Transform.rotate(
            angle: this.isExpanded ? pi / 1 : 0,
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: () => this.onChangeExpanded(!this.isExpanded),
            ),
          ),
          Expanded(child: Text(Consts.MASECHET_TITLE + masechetName)),
          CircularProgressIndicator(
            // backgroundColor: Colors.white,
            value: this.progressInPecent,
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}