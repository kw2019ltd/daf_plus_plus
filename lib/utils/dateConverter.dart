import 'package:daf_plus_plus/utils/localization.dart';

class DateConverterUtil {
  DateTime getToday() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  String toHebrewDate(DateTime date) {
    // TODO: to be implemented
    return "";
  }

  String getDayInWeek(DateTime date) {
    return localizationUtil.translate("calander", "days_in_week")[date.weekday%7];
  }

  String toEnglishDate(DateTime date) {
    int month = date?.month ?? -1;
    int day = date?.day ?? -1;
    if (month + day < 0) return "";
    String monthName = localizationUtil.translate("calander", "english_months")[month - 1];
    return monthName + " " + day.toString();
  }

  int getReletiveDateIndex(DateTime date) {
    return -1;
  }
}

final DateConverterUtil dateConverterUtil = DateConverterUtil();
