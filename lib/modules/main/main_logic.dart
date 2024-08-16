import 'dart:async';
import 'dart:io';

import 'package:ank_app/config/application.dart';
import 'package:ank_app/constants/app_global.dart';
import 'package:ank_app/entity/event/event_fullscreen.dart';
import 'package:ank_app/entity/event/logged_event.dart';
import 'package:ank_app/entity/event/theme_event.dart';
import 'package:ank_app/modules/chart/chart_logic.dart';
import 'package:ank_app/modules/home/home_logic.dart';
import 'package:ank_app/modules/market/contract/contract_coin/favorite/contract_coin_logic_f.dart';
import 'package:ank_app/modules/market/market_view.dart';
import 'package:ank_app/modules/news/news_view.dart';
import 'package:ank_app/modules/order_flow/order_flow_view.dart';
import 'package:ank_app/modules/setting/setting_logic.dart';
import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/activity_dialog.dart';
import 'package:async/async.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:screenshot_callback/screenshot_callback.dart';

import '../../entity/event/fgbg_type.dart';
import '../home/home_view.dart';
import '../setting/setting_view.dart';

class MainLogic extends GetxController {
  RxInt selectedIndex = 0.obs;
  List<Widget> tabPage = [
    const HomePage(),
    const MarketPage(),
    const OrderFlowPage(),
    const NewsPage(),
    const SettingPage(),
  ];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  InAppWebViewController? webViewController;
  bool isFirstKLine = true;
  final fullscreen = false.obs;

  StreamSubscription? _connectivitySubscription;
  StreamSubscription? appVisibleSubscription;
  final screenshotCallback = ScreenshotCallback();
  StreamSubscription? _fullscreenSubscription;

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void onReady() {
    AppUtil.checkUpdate(Get.context!);
    handleNetwork();
    AppUtil.syncSettingToHost();
    tryLogin();
    checkIfNeedOpenOrderFlow();
    getActivity();
    listenAppVisibility();
    listenScreenshot();
    _listenFullscreenEvent();
  }

  void _listenFullscreenEvent() {
    _fullscreenSubscription =
        AppConst.eventBus.on<EventFullscreen>().listen((event) {
      fullscreen.value = event.enable;
      Application.setSystemUiMode(fullscreen: event.enable);
    });
  }

  CancelableOperation? _cancelableOperationFg;
  CancelableOperation? _cancelableOperationBg;

  void listenAppVisibility() {
    appVisibleSubscription = AppConst.eventBus.on<FGBGType>().listen((event) {
      if (event == FGBGType.background) {
        _cancelableOperationBg = CancelableOperation.fromFuture(
          Future.delayed(const Duration(seconds: 10), () => true),
        );
        _cancelableOperationBg?.value
            .then((value) => AppConst.backgroundForAWhile = true);

        _cancelableOperationFg?.cancel();
        _cancelableOperationFg = null;
        Future.delayed(const Duration(milliseconds: 500),
            () => AppConst.foregroundForAWhile = false);
      } else {
        _cancelableOperationFg = CancelableOperation.fromFuture(
          Future.delayed(const Duration(seconds: 5), () => true),
        );
        _cancelableOperationFg?.value
            .then((value) => AppConst.foregroundForAWhile = true);

        _cancelableOperationBg?.cancel();
        _cancelableOperationBg = null;
        Future.delayed(const Duration(milliseconds: 500),
            () => AppConst.backgroundForAWhile = false);
      }
      AppConst.appVisible = event == FGBGType.foreground;
    });
  }

  bool _haveInitRequest = false;
  Future<void> handleNetwork() async {
    final connectivity = Connectivity();
    if (!AppConst.networkConnected) {
      AppUtil.showToast(S.current.error_network);
    }
    _connectivitySubscription =
        connectivity.onConnectivityChanged.listen((result) {
      AppConst.networkConnected = result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.other);
      if (AppConst.networkConnected && !_haveInitRequest) return;
      if (!AppConst.networkConnected) return;
      if (_haveInitRequest == true) return;
      _haveInitRequest = true;
      Application.instance.getConfig();
      getActivity();
      Get.find<HomeLogic>().onRefresh();
      Get.find<ContractCoinLogicF>().onRefresh();
      AppConst.eventBus.fire(ThemeChangeEvent(type: ThemeChangeType.locale));
      tryLogin();
      Get.find<ChartLogic>().onRefresh();
      Get.find<ChartLogic>().initTopData();
      Get.find<SettingLogic>().getAppSetting();
    });
  }

  void selectTab(int currentIndex) {
    if (currentIndex == 2) {
      Application.setSystemUiMode(fullscreen: fullscreen.value);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
      ]);
    } else {
      Application.setSystemUiMode();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
    if (selectedIndex.value != currentIndex) {
      selectedIndex.value = currentIndex;
    }
  }

  Future<void> tryLogin() async {
    final userInfo = StoreLogic.to.loginUserInfo;
    final pwd = AppUtil.decodeBase64(StoreLogic.to.loginPassword);
    final username = AppUtil.decodeBase64(StoreLogic.to.loginUsername);
    if (userInfo != null && pwd.isNotEmpty) {
      await Apis().login(username, pwd, StoreLogic.to.deviceId).then((value) {
        StoreLogic.to.saveLoginUserInfo(value);
        Future.delayed(
            const Duration(milliseconds: 500),
            () =>
                AppConst.eventBus.fire(LoginStatusChangeEvent(isLogin: true)));
      });
    }
  }

  Future<void> getActivity() async {
    if (AppConst.networkConnected == false) return;
    final data = await Apis().getActivityData(lan: AppUtil.shortLanguageName);
    if (data?.isShow == true) {
      Get.dialog(ActivityDialog(data: data!), barrierDismissible: false);
    }
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    _fullscreenSubscription?.cancel();
    appVisibleSubscription?.cancel();
    super.onClose();
  }

  Future<void> checkIfNeedOpenOrderFlow() async {
    if (kIsWeb || Platform.isIOS) return;
    final result = await MessageHostApi().getToKlineParams();
    // AppUtil.showToast(result?.toString() ?? 'nu');
    if (result == null) return;
    AppUtil.toKLine(
        result[0] ?? '', result[1] ?? '', result[2] ?? '', result[3] ?? '');
  }

  var lastImageId = '';
  var _lastScreenshotTime = DateTime.now();

  void listenScreenshot() {
    screenshotCallback.addListener(() {
      if (kIsWeb) return;
      if (!AppConst.appVisible) return;
      if (Platform.isAndroid && AppGlobal.justSavedImage) return;
      if (DateTime.now().difference(_lastScreenshotTime).inSeconds < 6) return;
      AppUtil.shareImage();
      _lastScreenshotTime = DateTime.now();
    });
  }
}

class BottomBarItem {
  final String icon; //未选中状态图标
  // final String activeIcon; //选中状态图标
  final String title; //文字

  BottomBarItem(
    this.icon,
    //this.activeIcon,
    this.title,
  );
}
