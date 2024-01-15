import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ank_app/entity/event/theme_event.dart';
import 'package:ank_app/entity/event/web_js_event.dart';
import 'package:ank_app/modules/home/exchange_oi/exchange_oi_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/urls.dart';
import '../entity/event/logged_event.dart';
import '../modules/main/main_logic.dart';
import '../modules/market/market_logic.dart';

class CommonWebView extends StatefulWidget {
  const CommonWebView({
    super.key,
    this.title,
    required this.url,
    this.urlGetter,
    this.onWebViewCreated,
    this.showLoading = false,
    this.safeArea = false,
    this.onLoadStop,
    this.dynamicTitle = false,
    this.enableShare = false,
  });

  final String? title;
  final String url;
  final String Function()? urlGetter;
  final void Function(InAppWebViewController controller)? onWebViewCreated;
  final VoidCallback? onLoadStop;
  final bool showLoading;
  final bool safeArea;
  final bool dynamicTitle;
  final bool enableShare;

  static Future<void> setCookieValue() async {
    final cookieList = <(String, String)>[];
    cookieList.addAll([
      ('theme', StoreLogic.to.isDarkMode ? 'night' : 'light'),
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
  StreamSubscription? _evJsSubscription;

  DateTime? lastLeftTime;
  StreamSubscription<FGBGType>? _fgbgSubscription;
  int _progress = 0;
  String _evJs = '';
  late String? title = widget.title;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _themeChangeSubscription =
        AppConst.eventBus.on<ThemeChangeEvent>().listen((event) async {
      await InAppWebViewController.clearAllCache();
      await CommonWebView.setCookieValue();
      reload();
    });
    _loginStatusSubscription =
        AppConst.eventBus.on<LoginStatusChangeEvent>().listen((event) async {
      await InAppWebViewController.clearAllCache();
      await CommonWebView.setCookieValue();
      reload();
    });
    _evJsSubscription =
        AppConst.eventBus.on<WebJSEvent>().listen((event) async {
      if (event.url == null) {
        _evJs = event.evJS;
      } else {
        if (widget.url == event.url || widget.urlGetter?.call() == event.url) {
          _evJs = event.evJS;
          webCtrl?.evaluateJavascript(source: _evJs);
        }
      }
    });
    // startWebRefreshCounter();
    super.initState();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    CommonWebView.setCookieValue().then((value) => reload());
  }

  void startWebRefreshCounter() {
    if (!Platform.isIOS) return;
    if (!(widget.url.contains('proChart') == true ||
        widget.urlGetter?.call().contains('proChart') == true)) return;
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

  Future<void> _share() async {
    final imageMemory = await webCtrl?.takeScreenshot(
        screenshotConfiguration: ScreenshotConfiguration());
    final screenShotCtrl = ScreenshotController();
    if (!mounted) return;
    var dialogWidget = SizedBox(
      child: Column(
        children: [
          Image.memory(imageMemory ?? Uint8List(0)),
          Container(
            height: 100,
            width: 100,
            color: Colors.red,
          ),
        ],
      ),
    );
    Get.dialog(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: dialogWidget,
    ));
    // screenShotCtrl.captureFromWidget(dialogWidget);
  }

  @override
  void dispose() {
    _themeChangeSubscription?.cancel();
    _loginStatusSubscription?.cancel();
    _fgbgSubscription?.cancel();
    _evJsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final canGoBack = await webCtrl?.canGoBack();
        if (canGoBack == true) {
          webCtrl?.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: title == null || !widget.enableShare
            ? null
            : AppTitleBar(
                title: title ?? '',
                onBack: () => navigator?.maybePop(),
                actionWidget: widget.enableShare
                    ? IconButton(
                        onPressed: _share, icon: const Icon(Icons.share))
                    : null),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: widget.safeArea ? AppConst.statusBarHeight : 0),
              child: InAppWebView(
                onTitleChanged: (controller, title) {
                  if (!widget.dynamicTitle) return;
                  if (this.title == title) return;
                  setState(() => this.title = title);
                },
                initialFile: !widget.url.startsWith('https://') &&
                        !widget.url.startsWith('http://')
                    ? widget.url
                    : null,
                initialUrlRequest: widget.url.startsWith('https://') ||
                        widget.url.startsWith('http://')
                    ? URLRequest(
                        url: WebUri(widget.urlGetter?.call() ?? widget.url))
                    : null,
                initialSettings: InAppWebViewSettings(
                  userAgent: Platform.isAndroid
                      ? 'CoinsohoWeb-flutter-Android'
                      : 'CoinsohoWeb-flutter-IOS',
                  // hardwareAcceleration: !widget.enableShare,
                  transparentBackground: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                ),
                onWebViewCreated: (controller) => _onWebViewCreated(controller),
                onLoadStop: (controller, url) => _onLoadStop(controller),
                onConsoleMessage: (controller, consoleMessage) =>
                    debugPrint(consoleMessage.toString()),
                onProgressChanged: (controller, progress) {
                  _progress = progress;
                  if (progress == 100) {
                    setState(() {});
                  }
                },
                onWebContentProcessDidTerminate: (controller) =>
                    controller.reload(),
              ),
            ),
            if (widget.showLoading && _progress != 100) const LottieIndicator(),
          ],
        ),
      ),
    );
  }

  void _onLoadStop(InAppWebViewController controller) {
    widget.onLoadStop?.call();
    if (widget.url.contains('proChart') ||
        widget.urlGetter?.call().contains('proChart') == true) {
      // controller.evaluateJavascript(
      //     source: "changeSymbolInfo('BTC')");
      if (_evJs.isNotEmpty) {
        controller
            .evaluateJavascript(source: _evJs)
            .then((value) => _evJs = '');
        _evJs = '';
      }
    }
  }

  void _onWebViewCreated(InAppWebViewController controller) {
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
      )
      ..addJavaScriptHandler(
        handlerName: 'openUrl',
        callback: (arguments) {
          if (arguments.isEmpty) return;
          AppNav.openWebUrl(
            url: arguments[0],
            dynamicTitle: true,
            showLoading: true,
          );
        },
      )
      ..addJavaScriptHandler(
        handlerName: 'openPage',
        callback: (arguments) {
          if (arguments.isEmpty) return;
          final uri = Uri.parse(arguments[0]);
          _handleOpenPage(uri);
        },
      )
      ..addJavaScriptHandler(
        handlerName: 'openUrlWithBrowser',
        callback: (arguments) {
          final url = Uri.parse(arguments[0]);
          launchUrl(url, mode: LaunchMode.externalApplication);
        },
      )
      ..addJavaScriptHandler(
        handlerName: 'copy',
        callback: (arguments) => AppUtil.copy(arguments[0]),
      )
      ..addJavaScriptHandler(
        handlerName: 'writeConfig',
        callback: (arguments) =>
            StoreLogic.to.saveWebConfig(arguments[0], arguments[1]),
      )
      ..addJavaScriptHandler(
        handlerName: 'readConfig',
        callback: (arguments) => StoreLogic.to.webConfig(arguments[0]),
      );
  }

  void _handleOpenPage(Uri uri) {
    if (uri.path == '/') {
      Get.until((route) => route.settings.name == '/');
      final pageType = uri.queryParameters['pageType'];
      if (pageType != null) {
        switch (pageType.toUpperCase()) {
          case 'FUNDINGRATE':
            Get.find<MainLogic>().selectTab(1);
            Get.find<MarketLogic>().selectIndex(4);
          case 'LIQDATA':
            Get.find<MainLogic>().selectTab(1);
            Future.delayed(const Duration(milliseconds: 100)).then((value) {
              AppConst.eventBus.fire(WebJSEvent(
                  evJS: uri.queryParameters['jsSource'] ?? '',
                  url: Urls.urlLiquidation));
            });
            Get.find<MarketLogic>().selectIndex(3);
          case 'EXCHANGEOI':
            Get.find<MainLogic>().selectTab(1);
            var marketLogic = Get.find<MarketLogic>();
            if (Get.isRegistered<ExchangeOiLogic>()) {
              var exchangeOiLogic = Get.find<ExchangeOiLogic>();
              exchangeOiLogic.menuParamEntity.value.baseCoin =
                  uri.queryParameters['baseCoin'];
              exchangeOiLogic.menuParamEntity.refresh();
              exchangeOiLogic.selectedCoinIndex = exchangeOiLogic.coinList
                  .indexOf(uri.queryParameters['baseCoin']);
              exchangeOiLogic.coinList.refresh();
              Loading.wrap(() async => exchangeOiLogic.onRefresh());
            } else {
              marketLogic.state.exchangeOIBaseCoin =
                  uri.queryParameters['baseCoin'];
            }
            marketLogic.selectIndex(1);
          case 'ORDERFLOW':
            var symbol = uri.queryParameters['symbol'] ?? '';
            var baseCoin = uri.queryParameters['baseCoin'] ?? '';
            var exchangeName = uri.queryParameters['exchangeName'] ?? '';
            var productType = uri.queryParameters['productType'];
            AppUtil.toKLine(exchangeName, symbol, baseCoin, productType);
        }
      } else {
        var tabIndex = int.tryParse(uri.queryParameters['tabIndex'] ?? '') ?? 0;
        Get.find<MainLogic>().selectTab(tabIndex);
        if (tabIndex == 1) {
          var subTabIndex =
              int.tryParse(uri.queryParameters['subTabIndex'] ?? '') ?? 0;
          Get.find<MarketLogic>().selectIndex(subTabIndex);
        }
      }
    } else {
      Get.toNamed(uri.path, arguments: uri.queryParameters);
    }
  }
}
