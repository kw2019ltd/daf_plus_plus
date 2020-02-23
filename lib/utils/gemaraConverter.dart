import 'dart:math';

import 'package:daf_counter/consts/consts.dart';

class GemaraConverterUtil {
  int firstCharValue = 'a'.codeUnitAt(0);

  String encode(List<int> gemaraProgress) {
    List<String> encodedGemaraProgress =
        gemaraProgress.map(_numberToString).toList();
    return encodedGemaraProgress.join();
  }

  List<int> decode(String gemaraProgress) {
    List<String> encodedGemaraProgress = gemaraProgress.split('');
    return encodedGemaraProgress.map(_stringToNumber).toList();
  }

  double toPercent(List<int> gemaraProgress) {
    int gemaraDone = gemaraProgress.where((int daf) => daf > 0).length;
    return gemaraDone / gemaraProgress.length;
  }

  String _numberToString(int number) {
    number = numberInRange(number);
    return String.fromCharCode(firstCharValue + number);
  }

  int _stringToNumber(String string) {
    int number = string.codeUnitAt(0);
    return numberInRange(number - firstCharValue);
  }

  int numberInRange(int number) =>
      max(0, min(number, Consts.MAX_REVISIONS));
}

final GemaraConverterUtil gemaraConverterUtil = GemaraConverterUtil();
