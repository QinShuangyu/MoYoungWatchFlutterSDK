import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin_example/utils/toast_util.dart';

export 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static show(String msgStr,Toast toast) {
    Fluttertoast.showToast(
        msg: msgStr,
        toastLength: toast,
        gravity: ToastGravity.CENTER,
        backgroundColor: const Color(0xff4B4B4B),
        textColor: Colors.white,
        fontSize: 13.0);
  }
}
