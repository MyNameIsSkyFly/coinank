import 'package:ank_app/res/export.dart';
import 'package:ank_app/route/app_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_logic.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final logic = Get.put(LoginLogic());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppTitleBar(
            actionWidget: TextButton(
                style: TextButton.styleFrom(
                    textStyle: Styles.tsBody_16(context),
                    foregroundColor:
                        Theme.of(context).textTheme.bodyMedium?.color),
                onPressed: AppNav.toRegister,
                child: Text(S.of(context).s_register))),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(10),
              Text(
                S.of(context).welcomeBack,
                style: Styles.tsBody_24(context)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const Gap(40),
              Text(
                S.of(context).email,
                style: Styles.tsBody_14(context),
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Gap(15),
                      TextFormField(
                        controller: logic.mailCtrl,
                        validator: (value) => AppUtil.isEmailValid(value ?? '')
                            ? null
                            : S.of(context).s_valid_emailaddress,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            prefixIconColor: Styles.cBody(context),
                            hintText: S.of(context).s_enter_account,
                            hintStyle: Styles.tsSub_14(context),
                            contentPadding: const EdgeInsets.all(15),
                            prefixIcon: const Icon(Icons.mail_outline)),
                      ),
                      const Gap(15),
                      TextFormField(
                        controller: logic.pwdCtrl,
                        validator: (value) => AppUtil.isPwdValid(value ?? '')
                            ? null
                            : S.of(context).s_valid_password,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                            prefixIconColor: Styles.cBody(context),
                            hintText: S.of(context).s_enter_password,
                            hintStyle: Styles.tsSub_14(context),
                            contentPadding: const EdgeInsets.all(15),
                            prefixIcon: const Icon(Icons.lock_outline_rounded)),
                      ),
                    ],
                  )),
              const Gap(15),
              GestureDetector(
                  onTap: () => AppNav.toFindPwd(),
                  child: Text(
                    S.of(context).s_forget_passwd,
                    style: Styles.tsMain_12,
                  )),
              const Gap(30),
              FilledButton(
                  onPressed: () {
                    if (!(formKey.currentState?.validate() ?? false)) return;
                    logic.login();
                  },
                  child: Text(S.of(context).s_login))
            ],
          ),
        ),
      ),
    );
  }
}
