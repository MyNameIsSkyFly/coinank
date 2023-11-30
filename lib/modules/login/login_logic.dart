import 'dart:convert';

import 'package:ank_app/entity/event/logged_event.dart';
import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/util/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../widget/common_webview.dart';

class LoginLogic extends GetxController {
  final mailCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();

  Future<void> login() async {
    final pwd = pwdCtrl.text;
    final mail = mailCtrl.text;
    final userInfo = await Apis().login(mail, pwd, StoreLogic.to.deviceId);

    AppUtil.showToast('SUCCESS');
    StoreLogic.to.saveLoginPassword(AppUtil.encodeBase64(pwd));
    StoreLogic.to.saveLoginUsername(AppUtil.encodeBase64(mail));
    StoreLogic.to.saveLoginUserInfo(userInfo);
    await CommonWebView.setCookieValue();
    StoreLogic.updateLoginStatus();
    AppConst.eventBus.fire(LoginStatusChangeEvent(isLogin: true));
    final json = {
      'success': true,
      'code': 1,
      'data': userInfo?.toJson(),
    };
    MessageHostApi().saveLoginInfo(jsonEncode(json));
    Get.back();
  }
}
