import 'dart:math';

import 'package:daf_counter/consts/shas.dart';

class GemaraConverterUtil {
  int firstCharValue = 'a'.codeUnitAt(0);

  String encode(List<int> gemaraProgress) {
    List<String> encodedGemaraProgress = gemaraProgress.map(numberToString).toList();
    return encodedGemaraProgress.join();
  }

  List<int> decode(String gemaraProgress) {
    List<String> encodedGemaraProgress = gemaraProgress.split('');
    return encodedGemaraProgress.map(stringToNumber).toList();
  }

  String numberToString(int number) {
    number = numberInRange(number);
    return String.fromCharCode(firstCharValue + number);
  }

  int stringToNumber(String string) {
    int number = string.codeUnitAt(0);
    return numberInRange(number - firstCharValue);
  }

  int numberInRange(int number) =>
      max(0, min(number, ShasConsts.MAX_REVISIONS));
}

final GemaraConverterUtil gemaraConverterUtil = GemaraConverterUtil();
