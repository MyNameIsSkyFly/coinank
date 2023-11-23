import 'dart:math';

import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/route/app_nav.dart';
import 'package:ank_app/util/store.dart';
import 'package:ank_app/widget/adaptive_dialog_action.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'setting_logic.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final logic = Get.put(SettingLogic());

  final state = Get.find<SettingLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppTitleBar(title: S.of(context).s_setting),
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const Gap(10),
                if (StoreLogic.isLogin)
                  _SettingLine(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => const _DeleteAccountDialog());
                    },
                    title: AppUtil.decodeBase64(StoreLogic.to.loginUsername),
                  ),
                const _ThemeChangeLine(),
                _SettingLine(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => const _KLineColorSelector());
                    },
                    title: S.of(context).s_klinecolor,
                    value: StoreLogic.to.isUpGreen
                        ? S.of(context).s_green_up
                        : S.of(context).s_red_up),
                _SettingLine(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => const _LanguageSelector());
                    },
                    title: S.of(context).s_language,
                    value: S.of(context).languageName),
                _SettingLine(
                  onTap: () {
                    AppNav.openWebUrl(
                      url: Urls.urlPrivacy,
                      title: S.of(context).privacyPolicy,
                    );
                  },
                  title: S.of(context).s_conditions_of_privacy,
                ),
                _SettingLine(
                  onTap: () {
                    AppNav.openWebUrl(
                      url: Urls.urlDisclaimer,
                      title: S.of(context).s_disclaimer,
                    );
                  },
                  title: S.of(context).s_disclaimer,
                ),
                _SettingLine(
                  onTap: () {
                    AppNav.openWebUrl(
                      url: Urls.urlAbout,
                      title: S.of(context).s_about_us,
                    );
                  },
                  title: S.of(context).s_about_us,
                ),
                Obx(() {
                  return _SettingLine(
                      onTap: () async {
                        var result = await Loading.wrap(
                            () async => AppUtil.needUpdate());
                        if (result.isNeed) {
                          if (!mounted) return;
                          showAdaptiveDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog.adaptive(
                                title: Text(
                                  S.of(context).s_is_upgrade,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color),
                                ),
                                backgroundColor: Theme.of(context).cardColor,
                                actions: [
                                  AdaptiveDialogAction(
                                      child: Text(S.of(context).s_cancel),
                                      onPressed: () {
                                        Get.back();
                                      }),
                                  AdaptiveDialogAction(
                                      child: Text(S.of(context).s_ok),
                                      onPressed: () async {
                                        await launchUrl(
                                            Uri.parse(result.jumpUrl),
                                            mode:
                                                LaunchMode.externalApplication);
                                        Get.back();
                                      }),
                                ],
                              );
                            },
                          );
                        }
                      },
                      title: S.of(context).s_check_update,
                      value: logic.versionName.value);
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: StoreLogic.isLogin
                ? FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).dividerTheme.color),
                    onPressed: () {
                      showAdaptiveDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog.adaptive(
                            title: Text(
                              '${S.of(context).s_exit_login}?',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color),
                            ),
                            backgroundColor: Theme.of(context).cardColor,
                            actions: [
                              AdaptiveDialogAction(
                                  child: Text(S.of(context).s_cancel),
                                  onPressed: () {
                                    Get.back();
                                  }),
                              AdaptiveDialogAction(
                                  child: Text(S.of(context).s_ok),
                                  onPressed: () async {
                                    await Loading.wrap(
                                        () async => logic.logout());
                                    Get.back();
                                  }),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      S.of(context).s_exit_login,
                      style: Styles.tsBody_16(context),
                    ))
                : FilledButton(
                    onPressed: AppNav.toLogin,
                    child: Text(S.of(context).s_login)),
          ),
          const Gap(44),
        ],
      ),
    );
  }
}

class _SettingLine extends StatelessWidget {
  const _SettingLine({
    required this.onTap,
    required this.title,
    this.value,
  });

  final VoidCallback? onTap;
  final String title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          children: [
            Expanded(child: Text(title, style: Styles.tsBody_16(context))),
            Text(
              value ?? '',
              style: Styles.tsSub_14(context),
            ),
            const Gap(5),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 15,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            )
          ],
        ),
      ),
    );
  }
}

class _ThemeChangeLine extends StatelessWidget {
  const _ThemeChangeLine();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        children: [
          Expanded(
              child: Text(
            S.of(context).s_themesetting,
            style: Styles.tsBody_16(context),
          )),
          GestureDetector(
            onTap: () => AppUtil.changeTheme(!(StoreLogic.to.isDarkMode ??
                Get.mediaQuery.platformBrightness == Brightness.dark)),
            child: Stack(
              children: [
                AnimatedContainer(
                  width: 40,
                  height: 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: StoreLogic.to.isDarkMode ??
                              Get.mediaQuery.platformBrightness ==
                                  Brightness.dark
                          ? const Color(0xffA1A7BB)
                          : Styles.cMain),
                  duration: const Duration(milliseconds: 200),
                ),
                AnimatedPositioned(
                    left: StoreLogic.to.isDarkMode ??
                            Get.mediaQuery.platformBrightness == Brightness.dark
                        ? 0
                        : 20,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: AnimatedSwitcher(
                          key: const ValueKey('DarkBtnAnimatedSwitcher'),
                          duration: const Duration(milliseconds: 200),
                          child: StoreLogic.to.isDarkMode ??
                                  Get.mediaQuery.platformBrightness ==
                                      Brightness.dark
                              ? const Icon(
                                  key: ValueKey('iconMoon'),
                                  CupertinoIcons.moon_fill,
                                  color: Colors.black,
                                  size: 15,
                                )
                              : const Icon(
                                  key: ValueKey('iconSun'),
                                  CupertinoIcons.sun_max_fill,
                                  color: Styles.cMain,
                                  size: 15,
                                )),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16)),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(10),
            Row(
              children: [
                const Gap(15),
                Text(S.of(context).s_language),
                const Spacer(),
                CloseButton(
                  color: Theme.of(context).textTheme.bodySmall!.color,
                  onPressed: Get.back,
                ),
              ],
            ),
            const Gap(20),
            ...[
              ('English', const Locale('en')),
              ('한국인', const Locale('ko')),
              ('日本語', const Locale('ja')),
              (
                '繁體中文',
                const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
              ),
              (
                '简体中文',
                const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans')
              )
            ].mapIndexed((index, s) => Container(
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  child: InkWell(
                    onTap: () {
                      AppUtil.changeLocale(s.$2);
                      Get.back();
                    },
                    child: Row(
                      children: [
                        Text(
                          s.$1,
                          style: Styles.tsBody_14m(context),
                        ),
                        const Spacer(),
                        if (s.$2 == StoreLogic.to.locale)
                          const Icon(
                            Icons.check,
                            color: Styles.cMain,
                            size: 20,
                          )
                      ],
                    ),
                  ),
                )),
            Gap(MediaQuery.of(context).padding.bottom + 20)
          ],
        ));
  }
}

class _KLineColorSelector extends StatelessWidget {
  const _KLineColorSelector();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16)),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(10),
          Row(
            children: [
              const Gap(15),
              Text(S.of(context).s_klinecolor),
              const Spacer(),
              CloseButton(
                color: Theme.of(context).textTheme.bodySmall!.color,
                onPressed: Get.back,
              ),
            ],
          ),
          const Gap(20),
          InkWell(
              onTap: () {
                if (StoreLogic.to.isUpGreen) return;
                AppUtil.toggleUpColor();
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Image.asset(
                      Assets.settingIcGreenUp,
                      width: 20,
                      height: 20,
                    ),
                    Expanded(child: Text(S.of(context).s_green_up)),
                    if (StoreLogic.to.isUpGreen)
                      const Icon(
                        Icons.check,
                        color: Styles.cMain,
                        size: 20,
                      )
                  ],
                ),
              )),
          InkWell(
            onTap: () {
              if (!StoreLogic.to.isUpGreen) return;
              AppUtil.toggleUpColor();
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Image.asset(
                    Assets.settingIcRedUp,
                    width: 20,
                    height: 20,
                  ),
                  Expanded(child: Text(S.of(context).s_red_up)),
                  if (!StoreLogic.to.isUpGreen)
                    const Icon(
                      Icons.check,
                      color: Styles.cMain,
                      size: 20,
                    )
                ],
              ),
            ),
          ),
          Gap(MediaQuery.of(context).padding.bottom + 20)
        ],
      ),
    );
  }
}

class _DeleteAccountDialog extends StatelessWidget {
  const _DeleteAccountDialog();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16)),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(10),
          Row(
            children: [
              const Gap(15),
              Text(S.of(context).s_setting),
              const Spacer(),
              CloseButton(
                color: Theme.of(context).textTheme.bodySmall!.color,
                onPressed: Get.back,
              ),
            ],
          ),
          const Gap(20),
          InkWell(
              onTap: () async {
                Loading.wrap(() async {
                  await Apis()
                      .sendCode(StoreLogic.to.loginUsername, 'logOff')
                      .whenComplete(() {
                    Get.back();
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => _DeleteAccountInputDialog(),
                    );
                  });
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(child: Text(S.of(context).s_deleteAccount)),
                    CupertinoListTileChevron(),
                  ],
                ),
              )),
          Gap(MediaQuery.of(context).padding.bottom + 20)
        ],
      ),
    );
  }
}

class _DeleteAccountInputDialog extends StatefulWidget {
  const _DeleteAccountInputDialog();

  @override
  State<_DeleteAccountInputDialog> createState() =>
      _DeleteAccountInputDialogState();
}

class _DeleteAccountInputDialogState extends State<_DeleteAccountInputDialog> {
  final formKey = GlobalKey<FormState>();
  final pwdCtrl = TextEditingController();
  final verifyCodeCtrl = TextEditingController();

  String? validVerifyCode(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.contains(' ') ||
        value.length != 6) {
      return S.current.s_verify_code_error;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16)),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(10),
          Row(
            children: [
              const Gap(15),
              Text(S.of(context).s_deleteAccount),
              const Spacer(),
              CloseButton(
                color: Theme.of(context).textTheme.bodySmall!.color,
                onPressed: Get.back,
              ),
            ],
          ),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: verifyCodeCtrl,
                      validator: (value) => validVerifyCode(value),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
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
                      ),
                    ),
                    const Gap(20),
                    TextFormField(
                      controller: pwdCtrl,
                      validator: (value) => AppUtil.isPwdValid(value ?? '')
                          ? null
                          : S.of(context).s_valid_password,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: S.of(context).s_enter_password,
                        filled: true,
                        prefixIconColor: Styles.cBody(context),
                        hintStyle: Styles.tsSub_14(context),
                        contentPadding: const EdgeInsets.all(15),
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          const Gap(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: FilledButton(
                onPressed: () async {
                  if (!(formKey.currentState?.validate() ?? false)) return;
                  await Apis().deleteAccount(StoreLogic.to.loginUsername,
                      pwdCtrl.text, verifyCodeCtrl.text);

                  Get.find<SettingLogic>().clearUserInfo();
                },
                child: Text(S.of(context).s_login)),
          ),
          Gap(max(MediaQuery.of(context).viewInsets.bottom,
                  MediaQuery.of(context).padding.bottom) +
              20)
        ],
      ),
    );
  }
}
