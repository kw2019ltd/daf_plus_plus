import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:flutter/material.dart';

import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/gematriaConverter.dart';

class DafWidget extends StatelessWidget {
  DafWidget({
    @required this.dafNumber,
    @required this.dafCount,
    @required this.onChangeCount,
    @required this.dafDate,
  });

  final int dafNumber;
  final int dafCount;
  final Function(int) onChangeCount;
  final DateTime dafDate;

  void _onClickCheckbox(bool state) {
    onChangeCount(state ? 1 : 0);
  }

  String _getDafNumber() {
    if (localizationUtil.translate("calendar", "display_dapim_as_gematria"))
      return gematriaConverterUtil
          .toGematria((dafNumber + Consts.FIST_DAF))
          .toString();
    return (dafNumber + Consts.FIST_DAF).toString();
  }

  String _theDate(dafDate) {
    String calendarType = hiveService.settings.getPreferredCalendar() ?? Consts.DEFAULT_CALENDAR_TYPE;
    if (calendarType == "english_calendar")
      return dateConverterUtil.toEnglishDate(dafDate);
    else if (calendarType == "hebrew_calendar")
      return dateConverterUtil.toHebrewDate(dafDate);
    return ""; 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: () => _onClickCheckbox(dafCount > 0 ? false : true),
        leading: Checkbox(
          onChanged: _onClickCheckbox,
          value: dafCount > 0 ? true : false,
        ),
        trailing: Text(
          dateConverterUtil.getDayInWeek(dafDate) +
              ", " +
              _theDate(dafDate),
          style: TextStyle(color: Colors.blueGrey),
        ),
        title: Text(localizationUtil.translate("general", "daf") +
            " " +
            _getDafNumber()),
      ),
    );
  }
}
