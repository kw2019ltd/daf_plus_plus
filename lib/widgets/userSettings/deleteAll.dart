import 'package:flutter/material.dart';

import 'package:daf_plus_plus/models/dafLocation.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/utils/localization.dart';

class DeleteAllWidget extends StatefulWidget {
  @override
  _DeleteAllWidgetState createState() => _DeleteAllWidgetState();
}

class _DeleteAllWidgetState extends State<DeleteAllWidget> {
  bool _deleteAllLoading = false;

  void _formatProgress() {
    Map<String, String> allProgress = hiveService.progress.getAllProgress();
    // TODO: also one of my worst codes in this project... 🤮
    allProgress = allProgress.map((String masechetId, String progress) =>
        MapEntry(masechetId,
            progress?.split('')?.map((String daf) => 'a')?.toList()?.join()));
    hiveService.progress.setAllProgress(allProgress);
    // TODO: never ever ever put the next line in prod
    hiveService.settings.setLastDaf(DafLocationModel.fromString('0-0'));
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
          onPressed: _formatProgress,
        ),
      ),
    );
  }
}
