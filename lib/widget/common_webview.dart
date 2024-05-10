import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ank_app/entity/event/theme_event.dart';
import 'package:ank_app/entity/event/web_js_event.dart';
import 'package:ank_app/modules/home/exchange_oi/exchange_oi_logic.dart';
import 'package:ank_app/modules/setting/setting_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/urls.dart';
import '../entity/event/logged_event.dart';
import '../modules/main/main_logic.dart';
import '../modules/market/contract/contract_logic.dart';
import '../modules/market/market_logic.dart';

class CommonWebView extends StatefulWidget {
  const CommonWebView({
    super.key,
    this.title,
    required this.url,
    this.urlGetter,
    this.onWebViewCreated,
    this.showLoading = false,
    this.onLoadStop,
    this.dynamicTitle = false,
    this.enableShare = false,
    this.gestureRecognizers,
    this.enableZoom = false,
    this.canPop = true,
  });

  final String? title;
  final String url;
  final String Function()? urlGetter;
  final void Function(InAppWebViewController controller)? onWebViewCreated;
  final void Function(InAppWebViewController controller)? onLoadStop;
  final bool showLoading;
  final bool dynamicTitle;
  final bool enableShare;
  final bool enableZoom;
  final bool canPop;
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  static Future<void> setCookieValue() async {
    final cookieManager = CookieManager.instance();

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
      ('i18n_redirected', AppUtil.shortLanguageName),
    ]);
    await cookieManager.deleteAllCookies();
    await _syncCookie(domain: Urls.h5Prefix, cookies: cookieList);
    //实时挂单数据url cookie
    await _syncCookie(domain: Urls.depthOrderDomain, cookies: cookieList);
    await _syncCookie(domain: Urls.uniappDomain, cookies: cookieList);
  }

  static Future<void> _syncCookie(
      {String? domain, required List<(String, String)> cookies}) async {
    if (domain == null) return;
    final expireDate = DateTime.now()..add(const Duration(days: 365));
    final cookieManager = CookieManager.instance();
    await Future.wait([
      ...cookies.map((e) => cookieManager.setCookie(
          url: WebUri(domain), name: e.$1, value: e.$2, maxAge: 31536000)),
      cookieManager.setCookie(
          url: WebUri(domain), name: 'Domain', value: domain, maxAge: 31536000),
      cookieManager.setCookie(
          url: WebUri(domain), name: 'Path', value: '/', maxAge: 31536000),
    ]);
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

  // DateTime? lastLeftTime;
  StreamSubscription<FGBGType>? _fgbgSubscription;
  int _progress = 0;
  String _evJs = '';
  late String? title = widget.title;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _themeChangeSubscription =
        AppConst.eventBus.on<ThemeChangeEvent>().listen((event) async {
      await CommonWebView.setCookieValue();
      reload();
    });
    _loginStatusSubscription =
        AppConst.eventBus.on<LoginStatusChangeEvent>().listen((event) async {
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
    startWebRefreshCounter();
    super.initState();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    CommonWebView.setCookieValue().then((value) => reload());
  }

  Timer? _titleTimer;

  void startWebRefreshCounter() {
    if (!Platform.isIOS) return;
    if (!(widget.url.contains('proChart') == true ||
        widget.urlGetter?.call().contains('proChart') == true)) return;
    _fgbgSubscription = FGBGEvents.stream.listen((event) {
      if (event == FGBGType.foreground) {
        _titleTimer = Timer(const Duration(seconds: 3), () {
          webCtrl?.getTitle().then((value) {
            if (value?.isEmpty case true || null) {
              reload();
            }
          });
        });
      } else {
        _titleTimer?.cancel();
        _titleTimer = null;
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
    _evJsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late Widget child;
    child = Stack(
      children: [
        InAppWebView(
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
              ? URLRequest(url: WebUri(widget.urlGetter?.call() ?? widget.url))
              : null,
          initialSettings: InAppWebViewSettings(
            isInspectable: true,
            userAgent: Platform.isAndroid
                ? 'CoinsohoWeb-flutter-Android'
                : 'CoinsohoWeb-flutter-IOS',
            // hardwareAcceleration: !widget.enableShare,
            transparentBackground: true,
            javaScriptCanOpenWindowsAutomatically: true,
            useHybridComposition:
                widget.urlGetter?.call().contains('proChart') == true,
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
          onWebContentProcessDidTerminate: (controller) => reload(),
          gestureRecognizers: widget.gestureRecognizers ??
              (widget.enableZoom
                  ? {
                      Factory<HorizontalDragGestureRecognizer>(
                        () => HorizontalDragGestureRecognizer(),
                      ),
                      Factory<PanGestureRecognizer>(
                        () => PanGestureRecognizer(),
                      ),
                      Factory<ForcePressGestureRecognizer>(
                        () => ForcePressGestureRecognizer(),
                      ),
                      Factory<LongPressGestureRecognizer>(
                        () => LongPressGestureRecognizer(),
                      ),
                    }
                  : null),
        ),
        if (widget.showLoading && _progress != 100) const LottieIndicator(),
      ],
    );
    if (title != null || widget.enableShare) {
      child = Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppTitleBar(
          title: title ?? '',
          onBack: () => navigator?.maybePop(),
          actionWidget: _actionWidget,
        ),
        body: child,
      );
    }
    if (widget.canPop) return child;
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
      child: child,
    );
  }

  Widget? get _actionWidget => widget.enableShare
      ? Row(
          children: [
            IconButton(
                onPressed: () => AppUtil.shareImage(),
                icon: const ImageIcon(AssetImage(Assets.commonIcShare))),
            if (widget.url.contains('users/noticeConfig') ||
                widget.urlGetter?.call().contains('users/noticeConfig') == true)
              IconButton(
                  onPressed: () => AppNav.openWebUrl(
                      showLoading: true,
                      title: S.of(context).noticeRecords,
                      url: Get.find<SettingLogic>()
                              .state
                              .settingList
                              .firstWhereOrNull((element) =>
                                  element.url?.contains('noticeRecords') ==
                                  true)
                              ?.url ??
                          ''),
                  icon: const ImageIcon(
                      AssetImage(Assets.commonIcNoticeHistory))),
          ],
        )
      : null;

  void _onLoadStop(InAppWebViewController controller) {
    widget.onLoadStop?.call(controller);
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
            title: '',
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
      )
      ..addJavaScriptHandler(
        handlerName: 'getAppVersion',
        callback: (arguments) =>
            '${AppConst.packageInfo?.version}+${AppConst.packageInfo?.buildNumber}',
      )
      ..addJavaScriptHandler(
          handlerName: 'isDarkMode',
          callback: (arguments) => StoreLogic().isDarkMode);
  }

  void _handleOpenPage(Uri uri) {
    if (uri.path == '/') {
      Get.until((route) => route.settings.name == '/');
      final pageType = uri.queryParameters['pageType'];
      var mainLogic = Get.find<MainLogic>();
      var marketLogic = Get.find<MarketLogic>();
      var contractLogic = Get.find<ContractLogic>();
      if (pageType != null) {
        switch (pageType.toUpperCase()) {
          case 'FUNDINGRATE':
            mainLogic.selectTab(1);
            marketLogic.selectIndex(0);
            contractLogic.selectIndex(4);
          case 'LIQDATA':
            mainLogic.selectTab(1);
            marketLogic.selectIndex(0);
            // Future.delayed(const Duration(milliseconds: 100)).then((value) {
            //   AppConst.eventBus.fire(WebJSEvent(
            //       evJS: uri.queryParameters['jsSource'] ?? '',
            //       url: Urls.urlLiquidation));
            // });
            contractLogic.selectIndex(3);
          case 'EXCHANGEOI':
            mainLogic.selectTab(1);
            marketLogic.selectIndex(0);
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
              contractLogic.state.exchangeOIBaseCoin =
                  uri.queryParameters['baseCoin'];
            }
            contractLogic.selectIndex(2);
          case 'ORDERFLOW':
            var symbol = uri.queryParameters['symbol'] ?? '';
            var baseCoin = uri.queryParameters['baseCoin'] ?? '';
            var exchangeName = uri.queryParameters['exchangeName'] ?? '';
            var productType = uri.queryParameters['productType'];
            AppUtil.toKLine(exchangeName, symbol, baseCoin, productType);
        }
      } else {
        var tabIndex = int.tryParse(uri.queryParameters['tabIndex'] ?? '') ?? 0;
        mainLogic.selectTab(tabIndex);
        marketLogic.selectIndex(0);
        if (tabIndex == 1) {
          var subTabIndex =
              int.tryParse(uri.queryParameters['subTabIndex'] ?? '') ?? 0;
          contractLogic.selectIndex(subTabIndex);
        }
      }
    } else {
      Get.toNamed(uri.path, arguments: uri.queryParameters);
    }
  }
}
