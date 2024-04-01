import 'dart:async';
import 'dart:io';

import 'package:ank_app/constants/app_global.dart';
import 'package:ank_app/entity/event/logged_event.dart';
import 'package:ank_app/entity/event/theme_event.dart';
import 'package:ank_app/modules/chart/chart_logic.dart';
import 'package:ank_app/modules/home/home_logic.dart';
import 'package:ank_app/modules/market/contract/contract_coin/favorite/contract_coin_logic_f.dart';
import 'package:ank_app/modules/setting/setting_logic.dart';
import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/activity_dialog.dart';
import 'package:async/async.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:screenshot_callback/screenshot_callback.dart';

import 'main_state.dart';

class MainLogic extends GetxController {
  final MainState state = MainState();
  StreamSubscription? _connectivitySubscription;
  StreamSubscription? appVisibleSubscription;
  final screenshotCallback = ScreenshotCallback();

  @override
  void onReady() {
    AppUtil.checkUpdate(Get.context!);
    handleNetwork();
    AppUtil.syncSettingToHost();
    tryLogin();
    checkIfNeedOpenOrderFlow();
    getActivity();
    initPackageInfo();
    listenAppVisibility();
    listenScreenshot();

    super.onReady();
  }

  CancelableOperation? _cancelableOperation;
  void listenAppVisibility() {
    appVisibleSubscription = FGBGEvents.stream.listen((event) {
      if (event == FGBGType.background) {
        _cancelableOperation = CancelableOperation.fromFuture(
          Future.delayed(const Duration(seconds: 10), () => true),
        );
        _cancelableOperation?.value
            .then((value) => AppConst.backgroundForAWhile = true);
      } else {
        _cancelableOperation?.cancel();
        _cancelableOperation = null;
        Future.delayed(const Duration(milliseconds: 500),
            () => AppConst.backgroundForAWhile = false);
      }
      AppConst.appVisible = event == FGBGType.foreground;
    });
  }

  Future<void> handleNetwork() async {
    var connectivity = Connectivity();
    if (!AppConst.networkConnected) {
      AppUtil.showToast(S.current.error_network);
    }
    _connectivitySubscription =
        connectivity.onConnectivityChanged.listen((result) {
      if (AppConst.networkConnected == true) return;
      AppConst.networkConnected = result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.other);
      if (AppConst.networkConnected) {
        getActivity();
        Get.find<HomeLogic>().onRefresh();
        if (StoreLogic.isLogin) Get.find<ContractCoinLogicF>().onRefresh();
        AppConst.eventBus.fire(ThemeChangeEvent(type: ThemeChangeType.locale));
        tryLogin();
        Get.find<ChartLogic>().onRefresh();
        Get.find<ChartLogic>().initTopData();
        Get.find<SettingLogic>().getAppSetting();
      }
    });
  }

  void selectTab(int currentIndex) {
    // if (state.isFirstKLine && currentIndex == 2) {
    //   state.isFirstKLine = false;
    // }
    if (state.selectedIndex.value != currentIndex) {
      state.selectedIndex.value = currentIndex;
    }
  }

  Future<void> tryLogin() async {
    final userInfo = StoreLogic.to.loginUserInfo;
    final pwd = AppUtil.decodeBase64(StoreLogic.to.loginPassword);
    final username = AppUtil.decodeBase64(StoreLogic.to.loginUsername);
    if (userInfo != null && pwd.isNotEmpty) {
      await Apis().login(username, pwd, StoreLogic.to.deviceId).then((value) {
        StoreLogic.to.saveLoginUserInfo(value);
        AppConst.eventBus.fire(LoginStatusChangeEvent(isLogin: true));
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
    appVisibleSubscription?.cancel();
    super.onClose();
  }

  Future<void> checkIfNeedOpenOrderFlow() async {
    if (Platform.isIOS) return;
    final result = await MessageHostApi().getToKlineParams();
    // AppUtil.showToast(result?.toString() ?? 'nu');
    if (result == null) return;
    AppUtil.toKLine(
        result[0] ?? '', result[1] ?? '', result[2] ?? '', result[3] ?? '');
  }

  Future<void> initPackageInfo() async {
    AppConst.packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isAndroid) {
      AppConst.deviceInfo = await DeviceInfoPlugin().androidInfo;
    }
  }

  var lastImageId = '';

  void listenScreenshot() {
    screenshotCallback.addListener(() {
      if (AppConst.canRequest == false) return;
      if (Platform.isAndroid && AppGlobal.justSavedImage) return;
      AppUtil.shareImage();
    });
  }
}
