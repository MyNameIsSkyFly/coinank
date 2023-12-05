import 'dart:async';

import 'package:ank_app/entity/event/logged_event.dart';
import 'package:ank_app/modules/chart/chart_drawer/chart_drawer_logic.dart';
import 'package:ank_app/modules/chart/chart_logic.dart';
import 'package:ank_app/modules/home/home_logic.dart';
import 'package:ank_app/modules/market/contract/contract_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/util/jpush_util.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';

import '../../widget/common_webview.dart';
import 'main_state.dart';

class MainLogic extends GetxController {
  final MainState state = MainState();
  StreamSubscription? _connectivitySubscription;

  @override
  void onReady() {
    CommonWebView.setCookieValue();
    AppUtil.checkUpdate(Get.context!);
    handleNetwork();
    super.onReady();
  }

  Future<void> handleNetwork() async {
    var connectivity = Connectivity();
    if (!AppConst.networkConnected) {
      AppUtil.showToast(S.current.networkConnectFailed);
    }
    _connectivitySubscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (AppConst.networkConnected == true) return;
      AppConst.networkConnected = result != ConnectivityResult.none;
      if (result != ConnectivityResult.none) {
        Get.find<HomeLogic>().onRefresh();
        Get.find<ContractLogic>().onRefresh();
        state.webViewController?.reload();
        tryLogin();
        Get.find<ChartLogic>().onRefresh();
        Get.find<ChartDrawerLogic>().onRefresh();
      }
    });
  }

  void selectTab(int currentIndex) {
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

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    FGBGEvents.stream.listen((event) {
      if (event == FGBGType.foreground) {
        JPushUtil.setBadge();
      }
    });
  }
}
