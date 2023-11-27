import 'package:ank_app/modules/home/exchange_oi/exchange_oi_view.dart';
import 'package:ank_app/modules/login/register_view.dart';
import 'package:get/get.dart';

import '../modules/login/login_view.dart';
import '../widget/common_webview.dart';

class AppNav {
  AppNav._();

  static Future<void> openWebUrl(
      {String? title, required String url, bool isFile = false}) async {
    await CommonWebView.setCookieValue();
    Get.to(() => CommonWebView(title: title, url: url, isFile: isFile));
  }

  static Future toLogin() async {
    Get.toNamed(LoginPage.routeName);
  }

  static Future toRegister() async {
    Get.toNamed(RegisterPage.routeName);
  }

  static Future toFindPwd() async {
    Get.toNamed(RegisterPage.routeName, arguments: {'isFindPwd': true});
  }

  static Future toExchangeOI() async {
    Get.toNamed(ExchangeOiPage.routeName);
  }
}
