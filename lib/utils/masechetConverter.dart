// import 'dart:math';

// import 'package:daf_plus_plus/consts/consts.dart';
// import 'package:daf_plus_plus/models/progress.dart';

// class MasechetConverterUtil {
//   String encode(List<int> progress) {
//     List<String> encodedProgress = progress.map(_numberToString).toList();
//     return encodedProgress.join(Consts.DATA_DIVIDER);
//   }

//   List<int> decode(String progress) {
//     List<String> decodedProgress = progress?.split(Consts.DATA_DIVIDER);
//     return decodedProgress?.map(_stringToNumber)?.toList();
//   }

//   List<int> emptyMasechet(int numOfDafs) => List.filled(numOfDafs, 0);

//   double toPercent(ProgressModel progress) {
//     int masechetDone = countDone(progress);
//     return masechetDone / progress.asList().length;
//   }

//   int countDone(ProgressModel progress) =>
//       progress.asList()?.where((int daf) => daf > 0)?.length;

//   String _numberToString(int number) => _numberInRange(number).toString();

//   int _stringToNumber(String string) => int.parse(string);

//   int _numberInRange(int number) => max(0, min(number, Consts.MAX_REVISIONS));
// }

// final MasechetConverterUtil masechetConverterUtil = MasechetConverterUtil();
