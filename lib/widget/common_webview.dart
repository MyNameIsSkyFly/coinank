import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ank_app/entity/event/theme_event.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/route/app_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../constants/urls.dart';
import '../entity/event/logged_event.dart';
import '../util/store.dart';

class CommonWebView extends StatefulWidget {
  const CommonWebView(
      {super.key,
      this.title,
      required this.url,
      this.urlGetter,
      this.onWebViewCreated});

  final String? title;
  final String url;
  final String Function()? urlGetter;
  final void Function(InAppWebViewController controller)? onWebViewCreated;

  static Future<void> setCookieValue() async {
    final cookieList = <(String, String)>[];
    cookieList.addAll([
      (
        'theme',
        StoreLogic.to.isDarkMode ??
                Get.mediaQuery.platformBrightness == Brightness.dark
            ? 'night'
            : 'light'
      ),
      (
        'COINSOHO_KEY',
        StoreLogic.to.loginUserInfo == null
            ? ' '
            : (StoreLogic.to.loginUserInfo!.token ?? ' ')
      ),
      ('green-up', StoreLogic.to.isUpGreen ? 'true' : 'false'),
    ]);
    cookieList.add(('i18n_redirected', AppUtil.shortLanguageName));

    await _syncCookie(domain: Urls.h5Prefix, cookies: cookieList);
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

  @override
  State<CommonWebView> createState() => _CommonWebViewState();
}

class _CommonWebViewState extends State<CommonWebView>
    with WidgetsBindingObserver {
  InAppWebViewController? webCtrl;

  StreamSubscription? _themeChangeSubscription;
  StreamSubscription? _loginStatusSubscription;
  DateTime? lastLeftTime;
  StreamSubscription<FGBGType>? _fgbgSubscription;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _themeChangeSubscription =
        AppConst.eventBus.on<ThemeChangeEvent>().listen((event) async {
      await webCtrl?.clearCache();
      await CommonWebView.setCookieValue();
      reload();
    });
    _loginStatusSubscription =
        AppConst.eventBus.on<LoginStatusChangeEvent>().listen((event) async {
      await webCtrl?.clearCache();
      await CommonWebView.setCookieValue();
      reload();
    });
    startWebRefreshCounter();
    super.initState();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    CommonWebView.setCookieValue().then((value) => reload());
  }

  void startWebRefreshCounter() {
    if (!Platform.isIOS) return;
    if (widget.url.contains('proChart') == false &&
        widget.urlGetter?.call().contains('proChart') == false) return;
    _fgbgSubscription = FGBGEvents.stream.listen((event) {
      if (event == FGBGType.foreground) {
        if (lastLeftTime != null &&
            DateTime.now().difference(lastLeftTime!) >
                const Duration(seconds: 15)) {
          reload();
        }
      } else if (event == FGBGType.background) {
        lastLeftTime = DateTime.now();
      }
    });
  }

  void reload() {
    if (widget.urlGetter == null) {
      webCtrl?.reload();
    } else {
      webCtrl?.loadUrl(
          urlRequest:
              URLRequest(url: WebUri(widget.urlGetter?.call() ?? widget.url)));
    }
  }

  @override
  void dispose() {
    _themeChangeSubscription?.cancel();
    _loginStatusSubscription?.cancel();
    _fgbgSubscription?.cancel();
    super.dispose();
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
          initialUrlRequest:
              URLRequest(url: WebUri(widget.urlGetter?.call() ?? widget.url)),
          initialSettings: InAppWebViewSettings(
              userAgent: 'CoinsohoWeb-flutter',
              javaScriptEnabled: true,
              transparentBackground: true,
              javaScriptCanOpenWindowsAutomatically: true),
          onWebViewCreated: (controller) {
            widget.onWebViewCreated?.call(controller);
            webCtrl = controller
              ..addJavaScriptHandler(
                handlerName: 'openLogin',
                callback: (arguments) {
                  AppNav.toLogin();
                },
              )
              ..addJavaScriptHandler(
                handlerName: 'getUserInfo',
                callback: (arguments) {
                  return jsonEncode(StoreLogic.to.loginUserInfo?.toJson());
                },
              );
          },
          onLoadStop: (controller, url) {
            controller.evaluateJavascript(source: "changeSymbolInfo('BTC')");
          },
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage.toString());
          },
        ),
      ),
    );
  }
}
