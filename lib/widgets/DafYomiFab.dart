import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/models/dafLocation.dart';
import 'package:daf_plus_plus/services/hive/datesBox.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/masechetConverter.dart';
import 'package:daf_plus_plus/utils/toast.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/core/infoDialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// TODO: oh, wow, there is a lot that can be improved here:
// 1. what if the button is pressed, do we undo it, tell him something about it
// 2. what if he didn't press the button but the daf was learned, is it any differant?
// 3. should we tell him what daf it is today?
// 4. an undo option in the toast (maybe snackbar)
// 5. if not doing the daf yomi, dont show

class DafYomiFabWidget extends StatelessWidget {
  // TODO: this function is from dialogs/firstUseDialogTwo. should have it in only one place.
  DafLocationModel _getTodaysDaf() {
    String today = DateFormat("MMMM d, y").format(DateTime.now());
    return DafLocationModel.fromMap(datesBox.getDafForDate(today));
  }

  void _displayInfo(BuildContext context) async {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => InfoDialogWidget(
          title: localizationUtil.translate('plus_plus_dialog_title'),
          text: localizationUtil.translate('plus_plus_dialog_text'),
          actionText: localizationUtil.translate('confirm_button'),
        ),
      ),
    );
  }

  void _learnedTodaysDaf() {
    DafLocationModel todaysDaf = _getTodaysDaf();
    List<int> progress = masechetConverterUtil
        .decode(hiveService.progress.getMasechetProgress(todaysDaf.masechetId));
    progress[todaysDaf.dafIndex] = 1; // TODO: really not ideal.
    String encodedProgress = masechetConverterUtil.encode(progress);
    progressAction.update(todaysDaf.masechetId, encodedProgress);
    hiveService.settings.setLastDaf(todaysDaf);
    toastUtil.showInformation(localizationUtil.translate('plus_plus_toast'));
  }

  void _checkIfFirstTime(BuildContext context) {
    bool isFirst = !hiveService.settings.getUsedFab();
    if (isFirst) {
      _displayInfo(context);
      hiveService.settings.setUsedFab(true);
    } else
      _learnedTodaysDaf();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _checkIfFirstTime(context),
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(
        "++",
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}
