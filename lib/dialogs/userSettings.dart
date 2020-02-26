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

  Future<bool> _newUserBackup() async {
    hiveService.settings.setLastUpdatedNow();
    Map<int, String> progress = hiveService.progress.getAllProgress();
    DafLocationModel lastDaf = hiveService.settings.getLastDaf();
    DateTime lastUpdated = hiveService.settings.getLastUpdated();
    await firestoreService.progress.setProgress(progress);
    await firestoreService.settings.updateSettings({
      FirestoreConsts.LAST_DAF: lastDaf.toString(),
      FirestoreConsts.LAST_UPDATED: lastUpdated,
    });
    return true;
  }

  Future<bool> _restoreUserData() async {
    // TODO: could wait for both together.
    ResponseModel settingsResponse =
        await firestoreService.settings.getSettings();
    if (!settingsResponse.isSuccessful()) return false;
    ResponseModel progressResponse =
        await firestoreService.progress.getProgress();
    if (!progressResponse.isSuccessful()) return false;
    Map<String, dynamic> settings = settingsResponse.data;
    Map<int, String> progress = progressResponse.data.map(
        (dynamic masechet, dynamic progress) =>
            MapEntry(int.parse(masechet), progress.toString()));

    // TODO: make this all a batch action
    hiveService.settings.setLastDaf(DafLocationModel.fromString(settings[FirestoreConsts.LAST_DAF]));
    hiveService.settings.setLastUpdated(settings[FirestoreConsts.LAST_UPDATED].toDate());
    hiveService.progress.setAllProgress(progress);
    return true;
  }

  Future<bool> _existingUserBackup() async {
    DateTime lastUpdated = hiveService.settings.getLastUpdated();
    if (lastUpdated == null) return _restoreUserData();
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
    if (restore) return _restoreUserData();
    return true;
  }

  Future<bool> _getProgress() async {
    ResponseModel progressResponse =
        await firestoreService.progress.getProgress();
    if (progressResponse.isSuccessful())
      return _existingUserBackup();
    else if (progressResponse.code == ResponsesConst.DOCUMENT_NOT_FOUND.code)
      return _newUserBackup();
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
    setState(() => _connectionLoading = false);
    _getProgress();
    toastUtil.showInformation("החשבון התחבר בהצלחה");
    // backup
  }

  void _onDisconnectGoogleAcount() async {
    setState(() => _connectionLoading = true);
    await authService.signOut();
    await _getAuthedState();
    toastUtil.showInformation("החשבון נותק בהצלחה");
    setState(() => _connectionLoading = false);
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
          onPressed: () {},
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
