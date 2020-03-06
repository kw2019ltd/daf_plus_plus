import 'dart:math';

import 'package:daf_plus_plus/consts/consts.dart';

class MasechetConverterUtil {

  String encode(List<int> progress) {
    List<String> encodedProgress =
        progress.map(_numberToString).toList();
    return encodedProgress.join(Consts.PROGRESS_DIVIDER);
  }

  List<int> decode(String progress) {
    List<String> decodedProgress = progress.split(Consts.PROGRESS_DIVIDER);
    return decodedProgress.map(_stringToNumber).toList();
  }

  double toPercent(List<int> progress) {
    int masechetDone = countDone(progress);
    return masechetDone / progress.length;
  }

  int countDone(List<int> masechetProgress) => masechetProgress.where((int daf) => daf > 0).length;

  String _numberToString(int number) => _numberInRange(number).toString();

  int _stringToNumber(String string) => int.parse(string);
  
  int _numberInRange(int number) =>  max(0, min(number, Consts.MAX_REVISIONS));
}

final MasechetConverterUtil masechetConverterUtil = MasechetConverterUtil();
