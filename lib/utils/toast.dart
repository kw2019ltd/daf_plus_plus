import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  void showInformation(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        fontSize: 16.0
    );
  }
}

final ToastUtil toastUtil = ToastUtil();