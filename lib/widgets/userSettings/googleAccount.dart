import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/consts/responses.dart';
import 'package:daf_plus_plus/models/Response.dart';
import 'package:daf_plus_plus/services/auth.dart';
import 'package:daf_plus_plus/services/firestore/index.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/toast.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/questionDialog.dart';

class GoogleAccountWidget extends StatefulWidget {
  @override
  _GoogleAccountWidgetState createState() => _GoogleAccountWidgetState();
}

class _GoogleAccountWidgetState extends State<GoogleAccountWidget> {
  bool _isAuthed = false;
  bool _connectionLoading = false;

  Future<void> _existingUserHasBackup() async {
    DateTime lastUpdated = hiveService.settings.getLastUpdated();
    if (lastUpdated == null)
      await progressAction.restore();
    else {
      bool restore = await Navigator.of(context).push(
        TransparentRoute(
          builder: (BuildContext context) => QuestionDialogWidget(
            title: localizationUtil.translate("general", "warning_title"),
            text: localizationUtil.translate("settings", "backup_warning_text"),
            trueActionText: localizationUtil.translate("settings", "use_backup_button"),
            falseActionText: localizationUtil.translate("settings", "delete_backup_button"),
          ),
        ),
      );
      if (restore) await progressAction.restore();
      await progressAction.backup();
    }
  }

  void _onConnectFail() {
    toastUtil.showInformation(
        localizationUtil.translate("settings", "toast_fail_connect_account"));
  }

  Future<void> _onConnectionSuccess() async {
    await _getAuthedState();
    ResponseModel progressResponse =
        await firestoreService.progress.getProgressMap();
    if (progressResponse.isSuccessful()) {
      await _existingUserHasBackup();
    } else if (progressResponse.code ==
        ResponsesConst.DOCUMENT_NOT_FOUND.code) {
      await progressAction.backup();
      toastUtil.showInformation(
          localizationUtil.translate("settings", "toast_success_connect_account"));
    } else {
      toastUtil.showInformation(
          localizationUtil.translate("settings", "toast_fail_connect_account"));
    }
  }

  void _onConnectGoogleAccount() async {
    setState(() => _connectionLoading = true);
    String userId = await authService.loginWithGoogle();
    if (userId == null) {
      _onConnectFail();
    } else {
      await _onConnectionSuccess();
    }
    setState(() => _connectionLoading = false);
  }

  void _onDisconnectGoogleAccount() async {
    setState(() => _connectionLoading = true);
    await authService.signOut();
    await _getAuthedState();
    toastUtil.showInformation(
        localizationUtil.translate("settings", "toast_success_disconnect_account"));
    setState(() => _connectionLoading = false);
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

  Widget _connectGoogleAccountWidget() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListTile(
        title: Text(localizationUtil.translate("settings", "settings_not_backedup_text")),
        subtitle: Text(localizationUtil.translate("settings", "settings_not_backedup_subtext")),
        trailing: ButtonWidget(
          text: localizationUtil.translate("settings", "connect_button"),
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
        title: Text(localizationUtil.translate("settings", "settings_backuped_text")),
        subtitle: Text(hiveService.settings.getLastBackup() != null ? localizationUtil.translate("settings", "settings_backuped_subtext") +
            DateFormat.yMd().add_Hm().format(hiveService.settings.getLastBackup()) : ""),
        trailing: ButtonWidget(
          text: localizationUtil.translate("settings", "disconnect_button"),
          buttonType: ButtonType.Outline,
          color: Theme.of(context).primaryColor,
          loading: _connectionLoading,
          disabled: _connectionLoading,
          onPressed: _onDisconnectGoogleAccount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isAuthed
        ? _disconnectGoogleAccountWidget()
        : _connectGoogleAccountWidget();
  }
}
