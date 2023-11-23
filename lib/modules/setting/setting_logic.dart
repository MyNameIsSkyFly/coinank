import 'package:ank_app/http/apis.dart';
import 'package:ank_app/util/store.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
    StoreLogic.updateLoginStatus();
  }
}
