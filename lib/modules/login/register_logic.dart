import 'dart:async';

import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterLogic extends GetxController {
  final sendBtnCounter = 0.obs;
  final agree = false.obs;
  final mailCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  final verifyCodeCtrl = TextEditingController();
  final referralCtrl = TextEditingController();
  bool isFindPwd = false;
  bool isChangePwd = false;

  @override
  void onInit() {
    super.onInit();
    // ignore: avoid_dynamic_calls
    isFindPwd = Get.arguments?['isFindPwd'] as bool? ?? false;
    // ignore: avoid_dynamic_calls
    isChangePwd = Get.arguments?['isChangePwd'] as bool? ?? false;
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
    final mail = mailCtrl.text.trim();
    final pwd = pwdCtrl.text;
    final verifyCode = verifyCodeCtrl.text;
    final referral = referralCtrl.text.isEmpty ? null : referralCtrl.text;
    await Apis().register(mail, pwd, verifyCode, strType, referral: referral);
    AppUtil.showToast(
        isFindPwd ? S.current.passwordChanged : S.current.registerSuccessfully);
    Get.back();
  }

  Future<void> forgetPwd() async {
    final mail = mailCtrl.text.trim();
    final pwd = pwdCtrl.text;
    final verifyCode = verifyCodeCtrl.text;
    await Apis().register(mail, pwd, verifyCode, strType);
    AppUtil.showToast(S.current.success_login);
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
    final mail = mailCtrl.text.trim();
    if (!AppUtil.isEmailValid(mail)) {
      AppUtil.showToast(S.current.s_valid_emailaddress);
      return;
    }
    await Loading.wrap(() async => Apis().sendCode(mail, strType));
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

  @override
  void onClose() {
    mailCtrl.dispose();
    pwdCtrl.dispose();
    verifyCodeCtrl.dispose();
    referralCtrl.dispose();
    super.onClose();
  }
}
