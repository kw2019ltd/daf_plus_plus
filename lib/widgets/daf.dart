import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/utils/gematriaConverter.dart';
import 'package:flutter/material.dart';

class DafWidget extends StatelessWidget {
  DafWidget({
    @required this.dafNumber,
    @required this.dafCount,
    @required this.onChangeCount,
    @required this.dafDate,
  });

  final int dafNumber;
  final int dafCount;
  final String dafDate;
  final Function(int) onChangeCount;

  void _onClickCheckbox(bool state) {
    onChangeCount(state ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Checkbox(
          onChanged: _onClickCheckbox,
          value: dafCount > 0 ? true : false,
        ),
        trailing: Text(dafDate, textScaleFactor: 0.8, style: TextStyle(color: Colors.blueGrey),),
        title: Text(Consts.DAF_TITLE + " " +
            gematriaConverter.toGematria((dafNumber + Consts.FIST_DAF))),
      ),
    );
  }
}
