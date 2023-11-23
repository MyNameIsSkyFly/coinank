import 'package:ank_app/http/apis.dart';
import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/util/store.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../constants/app_const.dart';
import '../../entity/event/logged_event.dart';
import 'setting_state.dart';

class SettingLogic extends GetxController {
  final SettingState state = SettingState();
  final versionName = RxString('');

  @override
  void onReady() {
    getVersionName();
  }

  Future<void> getVersionName() async {
    final pInfo = await PackageInfo.fromPlatform();
    versionName.value = pInfo.version;
  }

  Future<void> logout() async {
    await Apis().logout(header: StoreLogic.to.loginUserInfo?.token);
    await clearUserInfo();
  }

  Future<void> clearUserInfo() async {
    await StoreLogic.to.removeLoginUserInfo();
    await StoreLogic.to.removeLoginPassword();
    await StoreLogic.to.removeLoginUsername();
    MessageHostApi().saveLoginInfo('');
    StoreLogic.updateLoginStatus();
    await CommonWebView.setCookieValue();
    AppConst.eventBus.fire(LoginStatusChangeEvent(isLogin: false));
  }
}
