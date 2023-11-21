import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../constants/urls.dart';
import '../util/store.dart';

class CommonWebView extends StatefulWidget {
  const CommonWebView({super.key, this.title, required this.url});

  static Future<void> setCookieValue() async {
    final cookieManager = CookieManager.instance();
    final cookieList = <(String, String)>[];
    cookieList.addAll([
      (
        'theme',
        StoreLogic.to.isDarkMode ??
                Get.mediaQuery.platformBrightness == Brightness.dark
            ? 'dark'
            : 'light'
      ),
      ('COINSOHO_KEY', ' '),
      ('green-up', StoreLogic.to.isUpGreen ? 'true' : 'false'),
    ]);
    await _syncCookie(domain: Urls.strDomain, cookies: cookieList);
    cookieList.add(('i18n_redirected=', AppUtil.shortLanguageName));
    //实时挂单数据url cookie
    await _syncCookie(domain: Urls.depthOrderDomain, cookies: cookieList);
    await _syncCookie(domain: Urls.uniappDomain, cookies: cookieList);
  }

  static Future<void> _syncCookie(
      {String? domain, List<(String, String)>? cookies}) async {
    if (domain == null) return;
    final cookieManager = CookieManager.instance();
    if (cookies != null && cookies.isNotEmpty) {
      for (final cookie in cookies) {
        await cookieManager.setCookie(
            url: WebUri(domain), name: cookie.$1, value: cookie.$2);
      }
    }

    cookieManager.setCookie(url: WebUri(domain), name: 'Domain', value: domain);
    cookieManager.setCookie(url: WebUri(domain), name: 'Path', value: '/');
  }

  final String? title;
  final String url;

  @override
  State<CommonWebView> createState() => _CommonWebViewState();
}

class _CommonWebViewState extends State<CommonWebView> {
  InAppWebViewController? webCtrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title == null
          ? null
          : AppTitleBar(
              title: widget.title ?? '',
            ),
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
          initialSettings: InAppWebViewSettings(
              userAgent: 'CoinsohoWeb-flutter',
              javaScriptEnabled: true,
              transparentBackground: true,
              javaScriptCanOpenWindowsAutomatically: true),
          onWebViewCreated: (controller) {
            webCtrl = controller
              ..addJavaScriptHandler(
                handlerName: 'openLogin',
                callback: (arguments) {},
              );
          },
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage.toString());
          },
        ),
      ),
    );
  }
}
