import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/dafLocation.dart';
import 'package:daf_plus_plus/pages/home.dart';
import 'package:daf_plus_plus/services/hive/datesBox.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/gematriaConverter.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/toast.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/dialog.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class FirstUseReminder extends StatefulWidget {
  @override
  _FirstUseReminderState createState() => _FirstUseReminderState();
}

class _FirstUseReminderState extends State<FirstUseReminder> {
  TimeOfDay timeOfDay;
  String formattedTime;

  @override
  void initState() {
    super.initState();
    setState(() {
      formattedTime = localizationUtil.translate("select_time") + ":";
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _set(BuildContext context) {
    setNotification();
    Navigator.pop(context);
//    Navigator.pushReplacement(context,
//        MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    // TODO Set all daf done till current
  }

  _no(BuildContext context) {
    Navigator.pop(context);
//    Navigator.of(context).push(
//      TransparentRoute(
//        builder: (BuildContext context) => FirstUseDialogFillIn(),
//      ),
//    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      hasShadow: false,
      onTapBackground: () => Navigator.pop(context),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TitleWidget(
              title: localizationUtil.translate("welcome"),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(localizationUtil.translate("set_reminder"))),
                ListTile(
                  title: Text(
                    formattedTime,
                    textScaleFactor: 1.2,
                  ),
                  leading: Icon(Icons.access_time),
                  onTap: () async {
                    var pickedTime = await selectTime(context);
                    if (pickedTime != null)
                      setState(() {
                        timeOfDay = pickedTime;
                        formattedTime = timeFormat(timeOfDay);
                      });
                  },
                ),
                ListTile(
                  title: ButtonWidget(
                    text: localizationUtil.translate("set"),
                    buttonType: ButtonType.Outline,
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _set(context),
                  ),
                ),
                ListTile(
                  title: ButtonWidget(
                    text: localizationUtil.translate("dont_set"),
                    buttonType: ButtonType.Outline,
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _no(context),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future setNotification() async {
    if (timeOfDay != null) {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      var initializationSettingsAndroid =
      new AndroidInitializationSettings('ic_launcher');
      var initializationSettingsIOS = new IOSInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
      var initializationSettings = new InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);

      var time = Time(timeOfDay.hour, timeOfDay.minute, 0);
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'repeatDailyAtTime channel id',
          'repeatDailyAtTime channel name',
          'repeatDailyAtTime description');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          0,
          localizationUtil.translate('did_you_daf'),
          'd',
          time,
          platformChannelSpecifics);
    } else {
      toastUtil.showInformation(localizationUtil.translate("select_time"));
    }
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
//    await Navigator.push(
//      context,
//      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
//    );
  }

  // TODO: this function is from dialogs/firstUseDialogTwo. should have it in only one place.
  DafLocationModel _getTodaysDaf() {
    String today = DateFormat("MMMM d, y").format(DateTime.now());
    return DafLocationModel.fromMap(datesBox.getDafForDate(today));
  }

  String _getTodaysDafString() {
    DafLocationModel dafLocationModel = _getTodaysDaf();
    String m = localizationUtil.translate(MasechetsData
        .THE_MASECHETS[dafLocationModel.masechetId].translatedName);
    String d = gematriaConverter.toGematria(dafLocationModel.dafIndex + 1);
    return m + " " + d;
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(_getTodaysDafString()),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                new MaterialPageRoute(
                  // builder: (context) => new SecondScreen(payload),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Future<TimeOfDay> selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );
    if (picked != null) {
      return picked;
    }

    return null;
  }

  String timeFormat(TimeOfDay picked) {
    var hour = picked.hour;
    var Time = "";
    if (hiveService.settings.getPreferredLanguage() == "en") {
      if (picked.hour >= 12) {
        Time = "PM";
        if (picked.hour > 12) {
          hour = picked.hour - 12;
        } else if (picked.hour == 00) {
          hour = 12;
        } else {
          hour = picked.hour;
        }
      } else {
        Time = "AM";
        if (picked.hour == 00) {
          hour = 12;
        } else {
          hour = picked.hour;
        }
      }
    }
    var h, m;
    if (hour % 100 < 10) {
      h = "0" + hour.toString();
    } else {
      h = hour.toString();
    }

    int minute = picked.minute;
    if (minute % 100 < 10)
      m = "0" + minute.toString();
    else
      m = minute.toString();

    return h + ":" + m + " " + Time;
  }
}
