import 'package:daf_counter/services/auth.dart';
import 'package:daf_counter/utils/toast.dart';
import 'package:daf_counter/widgets/core/button.dart';
import 'package:daf_counter/widgets/core/dialog.dart';
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
        title: Text("גבה לחשבון גוגל"),
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
        title: Text("נתק חשבון גוגל"),
        trailing: ButtonWidget(
          text: "צא מהחשבון",
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
        title: Text("התחל מההתחלה"),
        trailing: ButtonWidget(
          text: "אפס",
          buttonType: ButtonType.Outline,
          color: Theme.of(context).primaryColor,
          loading: _deleteAllLoading,
          disabled: _deleteAllLoading,
          onPressed: _onDisconnectGoogleAcount,
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
