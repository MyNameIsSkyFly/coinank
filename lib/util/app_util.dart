import 'package:ank_app/modules/chart/chart_drawer/chart_drawer_logic.dart';
import 'package:ank_app/modules/chart/chart_logic.dart';
import 'dart:convert';

import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/util/format_util.dart';
import 'package:ank_app/util/store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
    if (Get.isRegistered<ChartLogic>()) {
      Get.find<ChartLogic>().onRefresh();
    }
    if (Get.isRegistered<ChartDrawerLogic>()) {
      Get.find<ChartDrawerLogic>().onRefresh();
    }
  }

  static String getLanguageSir() {
    if (StoreLogic.to.locale == const Locale('en')) {
      return 'en';
    }
    if (StoreLogic.to.locale ==
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')) {
      return 'zh-tw';
    }
    if (StoreLogic.to.locale ==
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans')) {
      return 'zh';
    }
    if (StoreLogic.to.locale == const Locale('ja')) {
      return 'ja';
    }
    if (StoreLogic.to.locale == const Locale('ko')) {
      return 'ko';
    }
    return 'zh';
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

  static String get webLanguage {
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

  static String get shortLanguageName {
    final locale = StoreLogic.to.locale;
    return switch (locale) {
      const Locale('en') => 'en',
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans') => 'zh',
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant') =>
        'zh-tw',
      const Locale('ja') => 'ja',
      const Locale('ko') => 'ko',
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

  static Future<({bool isNeed, String jumpUrl})> needUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final res = await Dio().get(
        'https://coinsoho.s3.us-east-2.amazonaws.com/app/androidwebversion.txt');
    final data = jsonDecode(res.data as String? ?? '{}');
    return (
      isNeed: (int.tryParse(packageInfo.buildNumber) ?? 10000) <
          (int.tryParse('${data['data']['ank_versionCode']}') ?? 0),
      jumpUrl: '${data['data']['ank_url']}'
    );
  }
}
