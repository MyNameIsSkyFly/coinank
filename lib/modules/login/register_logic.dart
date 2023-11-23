import 'dart:async';

import 'package:ank_app/res/export.dart';
import 'package:ank_app/util/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterLogic extends GetxController {
  final sendBtnCounter = 0.obs;
  final agree = false.obs;
  final mailCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  final verifyCodeCtrl = TextEditingController();
  bool isFindPwd = false;

  @override
  void onInit() {
    super.onInit();
    isFindPwd = Get.arguments?['isFindPwd'] as bool? ?? false;
    final lastTime = StoreLogic.to.lastSendCodeTime;
    final now = DateTime.now();
    if (now.difference(lastTime).inSeconds < 60) {
      sendBtnCounter.value = 60 - now.difference(lastTime).inSeconds;
      startCounter();
      return;
    }
  }

  String get strType => isFindPwd ? 'findPassWord' : 'register';

  Future<void> register() async {
    final mail = mailCtrl.text;
    final pwd = pwdCtrl.text;
    final verifyCode = verifyCodeCtrl.text;
    final userInfo = await Apis().register(mail, pwd, verifyCode, strType);
    AppUtil.showToast('SUCCESS');
    Get.back();
  }

  Future<void> forgetPwd() async {
    final mail = mailCtrl.text;
    final pwd = pwdCtrl.text;
    final verifyCode = verifyCodeCtrl.text;
    final userInfo = await Apis().register(mail, pwd, verifyCode, strType);
    AppUtil.showToast('SUCCESS');
    Get.back();
  }

  String? validVerifyCode(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.contains(' ') ||
        value.length != 6) {
      return S.current.s_verify_code_error;
    }
    return null;
  }

  Future<void> sendCode() async {
    if (!AppUtil.isEmailValid(mailCtrl.text)) {
      AppUtil.showToast(S.current.s_valid_emailaddress);
      return;
    }
    await Loading.wrap(() async => Apis().sendCode(mailCtrl.text, strType));
    await StoreLogic.to.saveLastSendCodeTime();
    sendBtnCounter.value = 60;
    startCounter();
  }


  void startCounter() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sendBtnCounter.value <= 0) {
        timer.cancel();
        return;
      }
      sendBtnCounter.value--;
    });
  }
}
