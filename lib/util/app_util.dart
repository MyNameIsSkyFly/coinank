// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:ank_app/config/application.dart';
import 'package:ank_app/entity/event/theme_event.dart';
import 'package:ank_app/entity/event/web_js_event.dart';
import 'package:ank_app/modules/chart/chart_logic.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/modules/setting/setting_logic.dart';
import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/util/format_util.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:ff_native_screenshot/ff_native_screenshot.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:screenshot_ntv/screenshot_ntv.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/adaptive_dialog_action.dart';
import '../widget/common_webview.dart';
import '../widget/share_dialog.dart';

class AppUtil {
  AppUtil._();

  static Future<void> updateAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    await Apis().getOtherInfo(
      deviceId: StoreLogic.to.deviceId,
      language: shortLanguageName,
      offset: DateTime.now().timeZoneOffset.inMilliseconds,
      deviceType: Platform.isAndroid ? 'android' : 'ios',
      pushPlatform: 'jpush',
      version: info.version,
    );
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
    AppUtil.updateAppInfo();
    StoreLogic.to.saveLocale(locale);
    CommonWebView.setCookieValue();
    if (Get.isRegistered<ChartLogic>()) {
      Get.find<ChartLogic>().onRefresh();
      Get.find<ChartLogic>().initTopData();
    }
    if (Get.isRegistered<SettingLogic>()) {
      Get.find<SettingLogic>().getAppSetting();
    }
  }

  static Future<void> changeTheme(bool? isDarkMode) async {
    await StoreLogic.to.saveDarkMode(isDarkMode);
    Get.changeThemeMode(isDarkMode == null
        ? ThemeMode.system
        : isDarkMode
            ? ThemeMode.dark
            : ThemeMode.light);
    Application.instance.initLoading();
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

  static String getLargeFormatString(dynamic val, {int precision = 1}) {
    if (val == null) return '0.${'0' * precision}';
    assert(val is String || val is double);
    final locale = (Get.locale ?? Get.deviceLocale).toString();
    double amount = val is String ? double.tryParse(val) ?? 0 : val;
    if (locale.isCaseInsensitiveContains('zh')) {
      return FormatUtil.amountConversion(amount, precision: precision);
    }
    final mFormat = NumberFormat('#,##0.${'0' * precision}', 'en_US');
    bool isNegative = amount < 0;
    amount = amount.abs();
    late String result;
    if (amount < 1000) {
      if (amount == 0) return '0.${'0' * precision}';
      result = amount.toStringAsFixed(precision);
    } else if (amount < 1000000) {
      result = '${mFormat.format(amount / 1000)}K';
    } else if (amount < 1000000000) {
      result = '${mFormat.format(amount / 1000000)}M';
    } else if (amount < 1000000000000) {
      result = '${mFormat.format(amount / 1000000000)}B';
    } else {
      result = '${mFormat.format(amount / 1000000000000)}T';
    }
    if (isNegative) {
      return '-$result';
    } else {
      return result;
    }
  }

  static String get webLanguage {
    final locale = StoreLogic.to.locale ?? Get.deviceLocale;
    if (locale?.languageCode == 'zh' && locale?.scriptCode == 'Hans') {
      return 'zh/';
    } else if (locale?.languageCode == 'zh' && locale?.scriptCode == 'Hant') {
      return 'zh-tw/';
    } else if (locale?.languageCode == 'ja') {
      return 'ja/';
    } else if (locale?.languageCode == 'ko') {
      return 'ko/';
    } else {
      return 'en/';
    }
  }

  static String get shortLanguageName {
    final locale = StoreLogic.to.locale ?? Get.deviceLocale;
    if (locale?.languageCode == 'zh' && locale?.scriptCode == 'Hans') {
      return 'zh';
    } else if (locale?.languageCode == 'zh' && locale?.scriptCode == 'Hant') {
      return 'zh-tw';
    } else if (locale?.languageCode == 'ja') {
      return 'ja';
    } else if (locale?.languageCode == 'ko') {
      return 'ko';
    } else {
      return 'en';
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
        return const Color(0xffEF424A);
      }
      if (rate * 100 < 0.01) {
        return const Color(0xff1DCA88);
      }
      return Theme.of(Get.context!).textTheme.bodyMedium!.color;
    }
    return Theme.of(Get.context!).textTheme.bodyMedium!.color;
  }

  static Future<void> checkUpdate(BuildContext context,
      {bool showLoading = false}) async {
    // if (kDebugMode) return;
    final packageInfo = await PackageInfo.fromPlatform();
    if (showLoading) Loading.show();
    final res = await Dio()
        .get(
            'https://coinsoho.s3.us-east-2.amazonaws.com/app/androidwebversion.txt')
        .whenComplete(() => Loading.dismiss());
    final data = jsonDecode(res.data as String? ?? '{}');
    bool isNeed = false;
    if (Platform.isIOS) {
      isNeed = (int.tryParse(packageInfo.buildNumber) ?? 100) <
          (int.tryParse('${data['data']['iosVersionCode']}') ?? 0);
    } else {
      isNeed = (int.tryParse(packageInfo.buildNumber) ?? 10000) <
          (int.tryParse(
                  '${data['data'][AppConst.isPlayVersion ? 'ank_googleVersionCode' : 'ank_versionCode']}') ??
              0);
    }
    final result = (
      isNeed: isNeed,
      jumpUrl: Platform.isIOS
          ? '${data['data']['iosurl']}'
          : '${data['data']['ank_url']}'
    );
    if (result.isNeed) {
      if (!context.mounted) return;
      showAdaptiveDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            title: Text(
              S.of(context).s_is_upgrade,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
            backgroundColor: Theme.of(context).cardColor,
            actions: [
              AdaptiveDialogAction(
                  child: Text(S.of(context).s_cancel),
                  onPressed: () {
                    Get.back();
                  }),
              AdaptiveDialogAction(
                  child: Text(S.of(context).s_ok),
                  onPressed: () async {
                    await launchUrl(Uri.parse(result.jumpUrl),
                        mode: LaunchMode.externalApplication);
                    Get.back();
                  }),
            ],
          );
        },
      );
    } else {
      if (!showLoading) return;
      AppUtil.showToast(S.current.s_last_version);
    }
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

  static Future<void> toKLine(String exchangeName, String symbol,
      String baseCoin, String? productType) async {
    Get.until((route) => route.settings.name == '/');
    if (Get.find<MainLogic>().isFirstKLine) {
      Get.find<MainLogic>().selectTab(2);
      Get.find<MainLogic>().isFirstKLine = false;
      await Future.delayed(const Duration(milliseconds: 100));
    }
    Map<String, dynamic> map = {
      'symbol': symbol,
      'baseCoin': baseCoin,
      'exchangeName': exchangeName,
      'productType': productType ?? 'SWAP',
    };
    String js = "flutterOpenKline('${jsonEncode(map)}');";
    AppConst.eventBus.fire(WebJSEvent(evJS: js));
    Get.find<MainLogic>().webViewController?.evaluateJavascript(source: js);
    // if (Get.find<MainLogic>().state.isFirstKLine) {
    //   Get.find<MainLogic>().state.isFirstKLine = false;
    // await Future.delayed(Duration(milliseconds: 100));
    // await Get.find<MainLogic>().state.webViewController?.reload();
    // }
    Get.find<MainLogic>().selectTab(2);
  }

  static void syncSettingToHost() {
    MessageHostApi()
        .changeLanguage((StoreLogic.to.locale ?? Get.deviceLocale).toString());
    MessageHostApi().changeDarkMode(StoreLogic.to.isDarkMode);
    MessageHostApi().changeUpColor(StoreLogic.to.isUpGreen);
  }

  static Future<void> shareImage({Uint8List? image}) async {
    if (Platform.isIOS) {
      image ??= await FfNativeScreenshot().takeScreenshot();
    } else {
      // ignore: parameter_assignments
      image ??= await ScreenshotNtv.takeScreenshot();
    }
    if (image == null) return;
    Get.dialog(ShareDialog(image: image), useSafeArea: false);
  }

  static String compressNumberWithLotsOfZeros(double original) {
    int countLeadingZeros(String str) {
      int count = 0;
      for (int i = 0; i < str.length; i++) {
        if (str[i] != '0') {
          break;
        }
        count++;
      }
      return count;
    }

    final number = Decimal.parse('$original');
    var split = number.toString().split('.');
    final integerPart = split[0];
    final decimalPart = split.elementAtOrNull(1);
    if (decimalPart == null) return number.toString();
    if (integerPart != '0') {
      return number.toString();
    } else {
      var count = countLeadingZeros(decimalPart);
      if (count >= 4) {
        return '$integerPart.{$count}${decimalPart.substring(count)}';
      } else {
        return number.toString();
      }
    }
  }
}
