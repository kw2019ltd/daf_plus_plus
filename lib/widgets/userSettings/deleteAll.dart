import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/core/questionDialog.dart';
import 'package:flutter/material.dart';

import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/utils/localization.dart';

class DeleteAllWidget extends StatefulWidget {
  @override
  _DeleteAllWidgetState createState() => _DeleteAllWidgetState();
}

class _DeleteAllWidgetState extends State<DeleteAllWidget> {
  bool _deleteAllLoading = false;

    Future<bool> _comfirmFormatProgress() async {
    bool shouldFormatProgress = await Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => QuestionDialogWidget(
          title: localizationUtil.translate('worning_title'),
          text: localizationUtil.translate('settings_reset_worning_text'),
          trueActionText: localizationUtil.translate('yes'),
          falseActionText: localizationUtil.translate('no'),
        ),
      ),
    );
    if (shouldFormatProgress) _formatProgress();
  }

  void _formatProgress() {
    Map<String, ProgressModel> progressMap = hiveService.progress.getProgressMap();
    // TODO: also one of my worst codes in this project... 🤮
    progressMap = progressMap.map(
        (String masechetId, ProgressModel progress) => MapEntry(masechetId, ProgressModel()));
    hiveService.progress.setProgressMap(progressMap);
    hiveService.settings.setLastDaf(DafModel.empty());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListTile(
        title: Text(localizationUtil.translate('settings_reset_text')),
        trailing: ButtonWidget(
          text: localizationUtil.translate('reset_button'),
          buttonType: ButtonType.Outline,
          color: Theme.of(context).primaryColor,
          loading: _deleteAllLoading,
          disabled: _deleteAllLoading,
          onPressed: _comfirmFormatProgress,
        ),
      ),
    );
  }
}
