import 'dart:io';

import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'setting_state.dart';

class SettingLogic extends GetxController {
  final SettingState state = SettingState();
  final versionName = RxString('');

  @override
  void onReady() {
    getVersionName();
    getAppSetting();
  }

  Future<void> getVersionName() async {
    final pInfo = await PackageInfo.fromPlatform();
    if (Platform.isAndroid) {
      versionName.value =
          '${AppConst.isPlayVersion ? 'GPlay AAB' : 'Apk'} ${pInfo.version}(${pInfo.buildNumber})';
    } else {
      versionName.value = pInfo.version;
    }
  }

  Future<void> logout() async {
    await Apis().logout(header: StoreLogic.to.loginUserInfo?.token);
    await StoreLogic.clearUserInfo();
  }

  String? mosaicEmail(String? name) {
    if (name == null) return null;
    if (name.contains('@')) {
      final List<String> parts = name.split('@');
      final String username = parts[0];
      final String domain = parts[1];
      if (username.isEmpty) {
        return name;
      } else if (username.length == 1) {
        return '${'*' * 6}@$domain';
      } else if (username.length == 2) {
        return '${username[0]}${'*' * 5}@$domain';
      } else {
        return '${username.substring(0, 2)}${'*' * 4}@$domain';
      }
    } else {
      if (name.isEmpty) {
        return name;
      } else if (name.length == 1) {
        return '*' * 6;
      } else if (name.length == 2) {
        return '${name[0]}${'*' * 5}';
      } else {
        return '${name.substring(0, 2)}${'*' * 4}';
      }
    }
  }

  Future<void> getAppSetting() async {
    if (AppConst.networkConnected == false) return;
    final data = await Apis().getAppSetting(lan: AppUtil.shortLanguageName);
    state.settingList.value = data ?? [];
  }
}
