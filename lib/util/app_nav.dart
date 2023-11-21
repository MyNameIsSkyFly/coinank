import 'package:get/get.dart';

import '../widget/common_webview.dart';

class AppNav {
  static Future<void> openWebUrl({String? title, required String url}) async {
    await CommonWebView.setCookieValue();
    Get.to(() => CommonWebView(title: title, url: url));
  }
}
