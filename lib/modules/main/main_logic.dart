import 'package:ank_app/entity/event/logged_event.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/util/jpush_util.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';

import '../../widget/common_webview.dart';
import 'main_state.dart';

class MainLogic extends GetxController {
  final MainState state = MainState();

  @override
  void onReady() {
    CommonWebView.setCookieValue();
    tryLogin();
    AppUtil.checkUpdate(Get.context!);
    super.onReady();
  }

  void selectTab(int currentIndex) {
    if (state.selectedIndex.value != currentIndex) {
      state.selectedIndex.value = currentIndex;
    }
  }

  void tryLogin() {
    final userInfo = StoreLogic.to.loginUserInfo;
    final pwd = AppUtil.decodeBase64(StoreLogic.to.loginPassword);
    final username = AppUtil.decodeBase64(StoreLogic.to.loginUsername);
    if (userInfo != null && pwd.isNotEmpty) {
      Apis().login(username, pwd, StoreLogic.to.deviceId).then((value) {
        StoreLogic.to.saveLoginUserInfo(value);
        AppConst.eventBus.fire(LoginStatusChangeEvent(isLogin: true));
      });
    }
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
