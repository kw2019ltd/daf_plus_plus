import 'package:daf_counter/services/hive/index.dart';
import 'package:daf_counter/utils/masechetConverter.dart';
import 'package:daf_counter/widgets/core/button.dart';
import 'package:daf_counter/widgets/core/dialog.dart';
import 'package:daf_counter/widgets/core/title.dart';
import 'package:flutter/material.dart';

class MasechetOptionsDialog extends StatelessWidget {

  MasechetOptionsDialog({
    @required this.masechetId,
    @required this.progress,
  });

  final int masechetId;
  final List<int> progress;

  _learnMasechet() {
    // TODO: this is probably the worst code i have written in this project.
    // but this needs to change to a counter and not a bool...
    String progress = masechetConverterUtil.encode(this.progress.map((daf) => 1).toList());
    hiveService.progress.setMasechetProgress(masechetId, progress);
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      onTapBackground: () => Navigator.pop(context),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TitleWidget(
              title: "אפשרויות נוספות",
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  title: ButtonWidget(
                    text: "למדתי את כל המסכת",
                    buttonType: ButtonType.Outline,
                    color: Theme.of(context).primaryColor,
                    onPressed: _learnMasechet,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
