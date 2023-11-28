import 'dart:convert';
import 'dart:io';

import 'package:ank_app/entity/event/theme_event.dart';
import 'package:ank_app/modules/chart/chart_drawer/chart_drawer_logic.dart';
import 'package:ank_app/modules/chart/chart_logic.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/res/export.dart';
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

import '../widget/common_webview.dart';

class AppUtil {
  AppUtil._();

  static Future<void> updateAppInfo() async {
    await Apis().getOtherInfo(
        deviceId: StoreLogic.to.deviceId,
        language: shortLanguageName,
        offset: DateTime.now().timeZoneOffset.inMilliseconds,
        deviceType: Platform.isAndroid ? 'android' : 'ios',
        pushPlatform: 'jpush');
  }

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
    AppConst.eventBus.fire(ThemeChangeEvent(type: ThemeChangeType.locale));
    StoreLogic.to.saveLocale(locale);
    CommonWebView.setCookieValue();
    if (Get.isRegistered<ChartLogic>()) {
      Get.find<ChartLogic>().onRefresh();
    }
    if (Get.isRegistered<ChartDrawerLogic>()) {
      Get.find<ChartDrawerLogic>().onRefresh();
    }
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
    AppConst.eventBus.fire(ThemeChangeEvent(type: ThemeChangeType.dark));
    CommonWebView.setCookieValue();
  }

  static void toggleUpColor() {
    final original = StoreLogic.to.isUpGreen;
    StoreLogic.to.saveUpGreen(!original);
    MessageHostApi().changeUpColor(!original);
    AppConst.eventBus.fire(ThemeChangeEvent(type: ThemeChangeType.upColor));
    Get.forceAppUpdate();
    CommonWebView.setCookieValue();
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
    final locale = StoreLogic.to.locale ?? Get.deviceLocale;
    if (locale?.languageCode == 'en') {
      return '';
    } else if (locale?.languageCode == 'zh' && locale?.scriptCode == 'Hant') {
      return 'zh-tw/';
    } else if (locale?.languageCode == 'ja') {
      return 'ja/';
    } else if (locale?.languageCode == 'ko') {
      return 'ko/';
    } else {
      return 'zh/';
    }
  }

  static String get shortLanguageName {
    final locale = StoreLogic.to.locale ?? Get.deviceLocale;
    if (locale?.languageCode == 'en') {
      return 'en';
    } else if (locale?.languageCode == 'zh' && locale?.scriptCode == 'Hant') {
      return 'zh-tw';
    } else if (locale?.languageCode == 'ja') {
      return 'ja';
    } else if (locale?.languageCode == 'ko') {
      return 'ko';
    } else {
      return 'zh';
    }
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

  static bool isEmailValid(String input) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(input);
  }

  static bool isPwdValid(String input) {
    final regex = RegExp(r'[^\u4E00-\u9FA5]{6,20}');
    return regex.hasMatch(input);
  }

  static String encodeBase64(String data) => base64.encode(utf8.encode(data));

  static String decodeBase64(String data) => utf8.decode(base64.decode(data));

  static void toKLine(String exchangeName, String symbol, String baseCoin,
      String? productType) {
    Map<String, dynamic> map = {
      'symbol': symbol,
      'baseCoin': baseCoin,
      'exchangeName': exchangeName,
      'productType': productType ?? 'SWAP',
    };
    String js = "flutterOpenKline('${jsonEncode(map)}');";
    Get.find<MainLogic>()
        .state
        .webViewController
        ?.evaluateJavascript(source: js);
    Get.find<MainLogic>().selectTab(2);
  }
}
