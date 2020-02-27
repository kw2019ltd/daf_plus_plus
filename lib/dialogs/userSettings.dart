import 'package:daf_counter/actions/backup.dart';
import 'package:daf_counter/consts/firestore.dart';
import 'package:daf_counter/consts/responses.dart';
import 'package:daf_counter/models/Response.dart';
import 'package:daf_counter/models/dafLocation.dart';
import 'package:daf_counter/services/auth.dart';
import 'package:daf_counter/services/firestore/index.dart';
import 'package:daf_counter/services/hive/index.dart';
import 'package:daf_counter/utils/toast.dart';
import 'package:daf_counter/utils/transparentRoute.dart';
import 'package:daf_counter/widgets/core/button.dart';
import 'package:daf_counter/widgets/core/dialog.dart';
import 'package:daf_counter/widgets/core/questionDialog.dart';
import 'package:daf_counter/widgets/core/title.dart';
import 'package:flutter/material.dart';

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
          title: "אופס",
          text:
              "נראה שיש לך מידע בגיבוי, האם תרצה למחוק את הנתונים הקיימים ולהשתמש בגיבוי?",
          trueActionText: "השתמש בגיבוי",
          falseActionText: "מחק את הגיבוי",
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
      toastUtil.showInformation("חיבור לחשבון כשל");
      return;
    }
    await _getAuthedState();
    await _getProgress();
    toastUtil.showInformation("החשבון התחבר בהצלחה");
    setState(() => _connectionLoading = false);
  }

  void _onDisconnectGoogleAcount() async {
    setState(() => _connectionLoading = true);
    await authService.signOut();
    await _getAuthedState();
    toastUtil.showInformation("החשבון נותק בהצלחה");
    setState(() => _connectionLoading = false);
  }

  void _formatProgress() {
    Map<int, String> allProgress = hiveService.progress.getAllProgress();
    // TODO: also one of my worst codes in this project... 🤮
    allProgress = allProgress.map((int masechetId, String progress) => MapEntry(
      masechetId, progress?.split('')?.map((String daf) => 'a')?.toList()?.join()
    ));
    hiveService.progress.setAllProgress(allProgress);
    // TODO: never ever ever put the next line in prod
    hiveService.settings.setLastDaf(DafLocationModel.fromString('0-0'));
    Navigator.pop(context);
  }

  Widget _connectGoogleAccountWidget() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListTile(
        title: Text("הנתונים אינם מגובים"),
        subtitle: Text("אם האפליקציה תמחק לא יהיה ניתן לשחזר את הנתונים שלך"),
        trailing: ButtonWidget(
          text: "התחבר",
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
        title: Text("הנתונים מגובים לחשבון גוגל"),
        subtitle: Text("גובה לאחרונה ב14/05/16 16:05"),
        trailing: ButtonWidget(
          text: "נתק",
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
        title: Text("למדת 137 דפים מתוך 3200, כל הכבוד!"),
        trailing: ButtonWidget(
          text: "אפס",
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
              title: "הגדרות משתמש",
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
