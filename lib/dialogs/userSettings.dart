import 'package:flutter/material.dart';

import 'package:daf_plus_plus/actions/backup.dart';
import 'package:daf_plus_plus/consts/responses.dart';
import 'package:daf_plus_plus/models/Response.dart';
import 'package:daf_plus_plus/models/dafLocation.dart';
import 'package:daf_plus_plus/services/auth.dart';
import 'package:daf_plus_plus/services/firestore/index.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/appLocalizations.dart';
import 'package:daf_plus_plus/utils/toast.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/dialog.dart';
import 'package:daf_plus_plus/widgets/core/questionDialog.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';

class UserSettingsDialog extends StatefulWidget {
  @override
  _UserSettingsDialogState createState() => _UserSettingsDialogState();
}

class _UserSettingsDialogState extends State<UserSettingsDialog> {
  bool _isAuthed = false;
  bool _connectionLoading = false;
  bool _deleteAllLoading = false;

  Future<bool> _existingUserBackup() async {
    DateTime lastUpdated = hiveService.settings.getLastUpdated();
    if (lastUpdated == null) return backupAction.restoreProgress();
    bool restore = await Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => QuestionDialogWidget(
          title: AppLocalizations.of(context).translate('worning_title'),
          text: AppLocalizations.of(context).translate('backup_worning_text'),
          trueActionText:
              AppLocalizations.of(context).translate('use_backup_button'),
          falseActionText:
              AppLocalizations.of(context).translate('delete_backup_button'),
        ),
      ),
    );
    if (restore) return backupAction.restoreProgress();
    return backupAction.backupProgress();
  }

  Future<bool> _getProgress() async {
    ResponseModel progressResponse =
        await firestoreService.progress.getProgress();
    if (progressResponse.isSuccessful())
      return _existingUserBackup();
    else if (progressResponse.code == ResponsesConst.DOCUMENT_NOT_FOUND.code)
      return backupAction.backupProgress();
    else
      return false;
  }

  void _onConnectGoogleAccount() async {
    setState(() => _connectionLoading = true);
    String userId = await authService.loginWithGoogle();
    if (userId == null) {
      setState(() => _connectionLoading = false);
      toastUtil.showInformation(
          AppLocalizations.of(context).translate('toast_fail_connect_account'));
      return;
    }
    await _getAuthedState();
    await _getProgress();
    toastUtil.showInformation(AppLocalizations.of(context)
        .translate('toast_success_connect_account'));
    setState(() => _connectionLoading = false);
  }

  void _onDisconnectGoogleAcount() async {
    setState(() => _connectionLoading = true);
    await authService.signOut();
    await _getAuthedState();
    toastUtil.showInformation(AppLocalizations.of(context)
        .translate('toast_success_disconnect_account'));
    setState(() => _connectionLoading = false);
  }

  void _formatProgress() {
    Map<int, String> allProgress = hiveService.progress.getAllProgress();
    // TODO: also one of my worst codes in this project... 🤮
    allProgress = allProgress.map((int masechetId, String progress) => MapEntry(
        masechetId,
        progress?.split('')?.map((String daf) => 'a')?.toList()?.join()));
    hiveService.progress.setAllProgress(allProgress);
    // TODO: never ever ever put the next line in prod
    hiveService.settings.setLastDaf(DafLocationModel.fromString('0-0'));
    Navigator.pop(context);
  }

  Widget _connectGoogleAccountWidget() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListTile(
        title: Text(AppLocalizations.of(context)
            .translate('settings_not_backedup_text')),
        subtitle: Text(AppLocalizations.of(context)
            .translate('settings_not_backedup_subtext')),
        trailing: ButtonWidget(
          text: AppLocalizations.of(context).translate('connect_button'),
          buttonType: ButtonType.Filled,
          color: Theme.of(context).primaryColor,
          loading: _connectionLoading,
          disabled: _connectionLoading,
          onPressed: _onConnectGoogleAccount,
        ),
      ),
    );
  }

  Widget _disconnectGoogleAccountWidget() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListTile(
        title: Text(
            AppLocalizations.of(context).translate('settings_backuped_text')),
        subtitle: Text(AppLocalizations.of(context)
                .translate('settings_backuped_subtext_1') +
            "12/15/19 14:20" +
            AppLocalizations.of(context)
                .translate('settings_backuped_subtext_2')),
        trailing: ButtonWidget(
          text: AppLocalizations.of(context).translate('disconnect_button'),
          buttonType: ButtonType.Outline,
          color: Theme.of(context).primaryColor,
          loading: _connectionLoading,
          disabled: _connectionLoading,
          onPressed: _onDisconnectGoogleAcount,
        ),
      ),
    );
  }

  Widget _deleteAllWidget() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListTile(
        title: Text(AppLocalizations.of(context)
                .translate('settings_reset_text_1') +
            "120" +
            AppLocalizations.of(context).translate('settings_reset_text_2') +
            "3700" +
            AppLocalizations.of(context).translate('settings_reset_text_3')),
        trailing: ButtonWidget(
          text: AppLocalizations.of(context).translate('reset_button'),
          buttonType: ButtonType.Outline,
          color: Theme.of(context).primaryColor,
          loading: _deleteAllLoading,
          disabled: _deleteAllLoading,
          onPressed: _formatProgress,
        ),
      ),
    );
  }

  Future<void> _getAuthedState() async {
    setState(() => _connectionLoading = true);
    bool isAuthed = await authService.isAuthed();
    setState(() {
      _isAuthed = isAuthed;
      _connectionLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getAuthedState();
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
              title: AppLocalizations.of(context).translate('settings_title'),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                _isAuthed
                    ? _disconnectGoogleAccountWidget()
                    : _connectGoogleAccountWidget(),
                _deleteAllWidget(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
