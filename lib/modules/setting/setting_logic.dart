import 'package:ank_app/http/apis.dart';
import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/util/store.dart';
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
    Apis().logout(header: StoreLogic.to.loginUserInfo?.token);
    await StoreLogic.to.removeLoginUserInfo();
    MessageHostApi().saveLoginInfo('');
    StoreLogic.updateLoginStatus();
    AppConst.eventBus.fire(LoginStatusChangeEvent(isLogin: false));
  }
}
