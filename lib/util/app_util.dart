import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../generated/l10n.dart';

class AppUtil {
  AppUtil._();

  static Future<void> showToast(String text) async {
    if (!kIsWeb) await Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      webBgColor: "linear-gradient(to right, #000000, #000000)",
      gravity: ToastGravity.BOTTOM,
      webPosition: 'center',
      fontSize: 16.0,
    );
  }

  static void copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    showToast(S.current.copied);
  }

  // static void changeLocale(Locale? locale) {
  //   if (locale == null) {
  //     Get.updateLocale(Get.deviceLocale ?? const Locale('en'));
  //   } else {
  //     Get.updateLocale(locale);
  //     try {
  //       S.load(locale);
  //     } catch (e) {
  //       S.load(const Locale('en'));
  //     }
  //   }
  //   SpData.saveLocale(locale?.languageCode ?? '');
  // }
}
