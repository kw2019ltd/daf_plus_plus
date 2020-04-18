import 'package:daf_plus_plus/models/progress.dart';
import 'package:flutter/material.dart';

import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/dialog.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';

class MasechetOptionsDialog extends StatelessWidget {
  MasechetOptionsDialog({
    @required this.masechetId,
    @required this.progress,
  });

  final String masechetId;
  final ProgressModel progress;

  _learnMasechet(BuildContext context) {
    // TODO: this is probably the worst code i have written in this project.
    // but this needs to change to a counter and not a bool...
    // String progress =
    //     masechetConverterUtil.encode(this.progress.map((daf) => 1).toList());
    // progressAction.updateMasechetProgress(context, masechetProgress);
    // Navigator.pop(context);
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
              title: localizationUtil.translate('masechet_options_title'),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  title: ButtonWidget(
                    text: localizationUtil.translate('learned_masechet'),
                    buttonType: ButtonType.Outline,
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _learnMasechet(context),
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
