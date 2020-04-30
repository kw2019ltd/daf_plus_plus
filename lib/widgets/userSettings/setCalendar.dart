import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:flutter/material.dart';

class SetCalendarWidget extends StatefulWidget {
  @override
  _SetCalendarWidgetState createState() => _SetCalendarWidgetState();
}

class _SetCalendarWidgetState extends State<SetCalendarWidget> {
  String _currentCalendar = "";
  List<String> _calendarsList = [""];

  void _changeCalendar(String calendar) {
    hiveService.settings.setPreferredCalendar(calendar);
    setState(() {
      _currentCalendar = calendar;
    });
  }

  void _getCalendars() {
    List<String> calendarsList =
        localizationUtil.translate("settings", "calendar_types").keys.toList();
    String currentCalendar = hiveService.settings.getPreferredCalendar() ??
        Consts.DEFAULT_CALENDAR_TYPE;
    setState(() {
      _currentCalendar = currentCalendar;
      _calendarsList = calendarsList;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCalendars();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListTile(
        title: Text(
            localizationUtil.translate("settings", "settings_calendar_text")),
        trailing: DropdownButton<String>(
          value: _currentCalendar,
          underline: Container(
            height: 2,
            color: Theme.of(context).primaryColor,
          ),
          onChanged: _changeCalendar,
          items:
              _calendarsList.map<DropdownMenuItem<String>>((String calendar) {
            return DropdownMenuItem<String>(
              value: calendar,
              child: Text(localizationUtil.translate(
                  "settings", "calendar_types")[calendar]),
            );
          }).toList(),
        ),
      ),
    );
  }
}
