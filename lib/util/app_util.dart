import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/util/format_util.dart';
import 'package:ank_app/util/store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
      webBgColor: 'linear-gradient(to right, #000000, #000000)',
      gravity: ToastGravity.BOTTOM,
      webPosition: 'center',
      fontSize: 16.0,
    );
  }

  static void copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    showToast(S.current.copied);
  }

  static void changeLocale(Locale? locale) {
    if (locale == null) {
      Get.updateLocale(Get.deviceLocale ?? const Locale('en'));
    } else {
      Get.updateLocale(locale);
      try {
        S.load(locale);
      } catch (e) {
        S.load(const Locale('en'));
      }
    }
    MessageHostApi().changeLanguage((locale ?? Get.deviceLocale).toString());
    StoreLogic.to.saveLocale(locale);
  }

  static void changeTheme(bool? isDarkMode) {
    StoreLogic.to.saveDarkMode(isDarkMode);
    Get.changeThemeMode(isDarkMode == null
        ? ThemeMode.system
        : isDarkMode
            ? ThemeMode.dark
            : ThemeMode.light);
    MessageHostApi().changeDarkMode(
        isDarkMode ?? Get.mediaQuery.platformBrightness == Brightness.dark);
  }

  static void toggleUpColor() {
    final original = StoreLogic.to.isUpGreen;
    StoreLogic.to.saveUpGreen(!original);
    MessageHostApi().changeUpColor(!original);
    Get.forceAppUpdate();
  }

  static String getLargeFormatString(String val) {
    final locale = Get.locale.toString();
    var amount = double.parse(val);
    if (locale.isCaseInsensitiveContains('zh')) {
      return FormatUtil.amountConversion(amount);
    }
    final mFormat = NumberFormat('#,##0.0', 'en_US');
    if (amount < 1000) {
      return amount.toString();
    } else if (amount < 1000000) {
      return '${mFormat.format(amount / 1000)}K';
    } else if (amount < 1000000000) {
      return '${mFormat.format(amount / 1000000)}M';
    } else {
      return '${mFormat.format(amount / 1000000000)}B';
    }
  }

  static String getWebLanguage() {
    final locale = StoreLogic.to.locale;
    return switch (locale) {
      const Locale('en') => '',
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans') => 'zh/',
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant') =>
        'zh-tw/',
      const Locale('ja') => 'ja/',
      const Locale('ko') => 'ko/',
      _ => ''
    };
  }

  static String getRate(
      {double? rate,
      required int precision,
      bool mul = true,
      bool showAdd = true}) {
    if (rate != null) {
      String s = '';
      if (mul) {
        s = '${(rate * 100).toStringAsFixed(precision)}%';
      } else {
        s = '${rate.toStringAsFixed(precision)}%';
      }
      if (s.startsWith('-')) return s;
      return showAdd ? '+$s' : s;
    }
    return '-';
  }

  static Color? getColorWithFundRate(double? rate) {
    if (rate != null) {
      if (rate * 100 > 0.01) {
        return const Color(0xffD8494A);
      }
      if (rate * 100 < 0.01) {
        return const Color(0xff5CC389);
      }
      return Theme.of(Get.context!).textTheme.bodyMedium!.color;
    }
    return Theme.of(Get.context!).textTheme.bodyMedium!.color;
  }
}
