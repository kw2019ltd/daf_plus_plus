import 'package:daf_counter/consts/consts.dart';
import 'package:daf_counter/utils/gematriaConverter.dart';
import 'package:flutter/material.dart';

class DafWidget extends StatelessWidget {
  DafWidget({
    @required this.dafNumber,
    @required this.dafCount,
    @required this.onChangeCount,
  });

  final int dafNumber;
  final int dafCount;
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
        title: Text(Consts.DAF_TITLE + " " +
            gematriaConverter.toGematria((dafNumber + Consts.FIST_DAF))),
      ),
    );
  }
}
