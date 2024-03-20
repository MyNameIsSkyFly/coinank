import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/modules/coin_detail/coin_detail_view.dart';
import 'package:ank_app/modules/login/register_view.dart';
import 'package:ank_app/modules/market/market_category/category_detail/category_detail_view.dart';
import 'package:ank_app/modules/setting/about/about_view.dart';
import 'package:ank_app/modules/setting/contact_us/contact_us_view.dart';
import 'package:get/get.dart';

import '../modules/login/login_view.dart';
import '../widget/common_webview.dart';

class AppNav {
  AppNav._();

  static Future<void> openWebUrl(
      {String? title,
      required String url,
      bool showLoading = false,
      bool dynamicTitle = false}) async {
    await CommonWebView.setCookieValue();
    Get.to(
      preventDuplicates: false,
      () => CommonWebView(
        title: title,
        url: url,
        enableShare: true,
        showLoading: showLoading,
        dynamicTitle: dynamicTitle,
        canPop: false,
      ),
    );
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

  static Future toContactUs() async {
    Get.toNamed(ContactUsPage.routeName);
  }

  static Future toAbout() async {
    Get.toNamed(AboutPage.routeName);
  }

  static Future toCoinDetail(MarkerTickerEntity coin,
      {bool toSpot = false}) async {
    Get.toNamed(CoinDetailPage.routeName,
        arguments: {'coin': coin, 'toSpot': toSpot});
  }

  static Future toCategoryDetail({required String? tag}) async {
    Get.toNamed(
      CategoryDetailPage.routeName,
      arguments: {'tag': tag},
    );
  }
}
