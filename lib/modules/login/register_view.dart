import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/urls.dart';
import '../../res/export.dart';
import 'register_logic.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const String routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final logic = Get.put(RegisterLogic());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const AppTitleBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: [
              const Gap(10),
              Text(
                logic.isFindPwd
                    ? S.of(context).s_forget_passwd
                    : S.of(context).s_register,
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
                            hintText: S.of(context).s_enter_account,
                            hintStyle: Styles.tsSub_14(context),
                            contentPadding: const EdgeInsets.all(15),
                            prefixIconColor: Styles.cBody(context),
                            prefixIcon: const Icon(Icons.mail_outline)),
                      ),
                      const Gap(15),
                      TextFormField(
                        controller: logic.verifyCodeCtrl,
                        validator: (value) => logic.validVerifyCode(value),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: S.of(context).s_verify_code,
                            hintStyle: Styles.tsSub_14(context),
                            contentPadding: const EdgeInsets.all(15),
                            prefixIconColor: Styles.cBody(context),
                            prefixIcon: const SizedBox.square(
                              dimension: 48,
                              child: Center(
                                child: ImageIcon(
                                  AssetImage(Assets.imagesIcVerifyCode),
                                  size: 24,
                                ),
                              ),
                            ),
                            suffixIcon: Obx(() {
                              return TextButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor: Styles.cMain,
                                      disabledForegroundColor: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color),
                                  onPressed: logic.sendBtnCounter.value > 0
                                      ? null
                                      : () {
                                          logic.sendCode();
                                        },
                                  child: Text(logic.sendBtnCounter.value == 0
                                      ? S.of(context).s_send_verify_code
                                      : '${logic.sendBtnCounter.value}s'));
                            })),
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
                            hintText: S.of(context).s_enter_password,
                            prefixIconColor: Styles.cBody(context),
                            hintStyle: Styles.tsSub_14(context),
                            contentPadding: const EdgeInsets.all(15),
                            prefixIcon: const Icon(Icons.lock_outline_rounded)),
                      ),
                      const Gap(15),
                      TextFormField(
                        controller: logic.referralCtrl,
                        decoration: InputDecoration(
                          hintText: S.of(context).plsInputReferral,
                          prefixIconColor: Styles.cBody(context),
                          hintStyle: Styles.tsSub_14(context),
                          contentPadding: const EdgeInsets.all(15),
                          prefixIcon: const SizedBox.square(
                            dimension: 48,
                            child: Center(
                              child: ImageIcon(
                                AssetImage(Assets.imagesIcReferral),
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              const Gap(15),
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                        child: GestureDetector(
                      onTap: logic.agree.toggle,
                      child: Obx(() {
                        return Container(
                          width: 15,
                          height: 15,
                          margin: const EdgeInsets.only(right: 3),
                          child: logic.agree.value
                              ? const Icon(
                                  CupertinoIcons.checkmark_alt_circle,
                                  color: Styles.cMain,
                                  size: 15,
                                )
                              : Icon(
                                  CupertinoIcons.circle,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                  size: 15,
                                ),
                        );
                      }),
                    )),
                    TextSpan(
                      text: S.of(context).iAgree,
                      style: Styles.tsBody_12(context),
                    ),
                    const WidgetSpan(child: SizedBox(width: 3)),
                    TextSpan(
                        text: 'CoinAnk${S.of(context).s_disclaimer}',
                        style: Styles.tsMain_12,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            AppNav.openWebUrl(
                              url: Urls.urlDisclaimer,
                              title: S.of(context).s_disclaimer,
                            );
                          }),
                    const WidgetSpan(child: SizedBox(width: 3)),
                    TextSpan(
                      text: S.of(context).and,
                      style: Styles.tsBody_12(context),
                    ),
                    const WidgetSpan(child: SizedBox(width: 3)),
                    TextSpan(
                        text: S.of(context).privacyPolicy,
                        style: Styles.tsMain_12,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            AppNav.openWebUrl(
                              url: Urls.urlPrivacy,
                              title: S.of(context).s_conditions_of_privacy,
                            );
                          })
                  ],
                ),
              ),
              const Gap(30),
              FilledButton(
                  onPressed: () {
                    if (!(formKey.currentState?.validate() ?? false)) return;
                    Loading.wrap(() async => logic.register());
                  },
                  child: Text(logic.isFindPwd
                      ? S.of(context).s_ok
                      : S.current.s_register))
            ],
          ),
        ),
      ),
    );
  }
}
