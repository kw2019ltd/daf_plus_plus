import 'package:daf_plus_plus/utils/localization.dart';

class DateConverterUtil {
  String toHebrewDate(DateTime date) {
    return "";
  }

  String toEnglishDate(DateTime date) {
    int month = date?.month ?? -1;
    int day = date?.day ?? -1;
    if (month + day < 0) return "";
    String monthName = localizationUtil.translate('english_months')[month - 1];
    return monthName + " " + day.toString();
  }

  int getReletiveDateIndex(DateTime date) {
    return -1;
  }
}

final DateConverterUtil dateConverterUtil = DateConverterUtil();
