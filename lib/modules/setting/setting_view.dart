import 'dart:io';
import 'dart:math';

import 'package:ank_app/entity/app_setting_entity.dart';
import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/adaptive_dialog_action.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/urls.dart';
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
      appBar: AppBar(
        toolbarHeight: 44,
        leadingWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(S.of(context).s_setting,
                  style: Styles.tsBody_18(context)
                      .copyWith(fontWeight: FontWeight.w700))),
        ),
        actions: [
          IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => StoreLogic.isLogin
                  ? AppNav.openWebUrl(
                      title: S.current.s_add_alert,
                      url: Urls.urlNotification,
                      showLoading: true,
                    )
                  : AppNav.toLogin(),
              icon:
                  const ImageIcon(AssetImage(Assets.settingIcBell), size: 20)),
          const Gap(10),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const Gap(10),
                if (StoreLogic.isLogin) ...[
                  _SettingLine(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => const _DeleteAccountDialog());
                    },
                    title: logic.mosaicEmail(AppUtil.decodeBase64(
                            StoreLogic.to.loginUsername)) ??
                        '',
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              Theme.of(context).brightness == Brightness.dark
                                  ? Assets.settingBgInviteDark
                                  : Assets.settingBgInvite,
                            ))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(S.of(context).inviteScore,
                                style: Styles.tsBody_14(context).semibold),
                            Text('${StoreLogic.to.loginUserInfo?.score ?? 0}',
                                style: Styles.tsMain_14.semibold),
                            const Gap(10),
                            const Icon(Icons.keyboard_arrow_right_rounded,
                                size: 18),
                          ],
                        ),
                        const Gap(5),
                        GestureDetector(
                          onTap: () => AppUtil.copy(
                              StoreLogic.to.loginUserInfo?.referralCode ?? ''),
                          child: Row(
                            children: [
                              Text(
                                  S.of(context).invitationCodeX(StoreLogic
                                          .to.loginUserInfo?.referralCode ??
                                      ''),
                                  style: Styles.tsSub_12(context)),
                              const Gap(5),
                              ImageIcon(const AssetImage(Assets.commonIcCopy),
                                  size: 15, color: Styles.cSub(context)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
                Obx(() {
                  var settingList = state.settingList.where((e) =>
                      e.isShow == true &&
                      e.url?.contains('noticeRecords') != true);
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: settingList.length,
                    itemBuilder: (cnt, index) {
                      AppSettingEntity item = settingList.toList()[index];
                      return _SettingLine(
                        onTap: () {
                          if (item.openType == '1') {
                            launchUrl(Uri.parse(item.url ?? ''));
                          } else if (item.openType == '2') {
                            AppNav.openWebUrl(
                              url: item.url ?? '',
                              title: item.name ?? '',
                              showLoading: true,
                            );
                          }
                        },
                        title: item.name ?? '',
                      );
                    },
                  );
                }),
                if (Platform.isAndroid)
                  _SettingLine(
                    onTap: () {
                      MessageHostApi().toAndroidFloatingWindow();
                    },
                    title: S.of(context).s_floatviewsetting,
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
                  onTap: () =>
                      Share.shareUri(Uri.parse('https://coinank.com/download')),
                  title: S.of(context).shareApp,
                ),
                _SettingLine(
                  onTap: () => AppNav.toContactUs(),
                  title: S.of(context).contactUs,
                ),
                Obx(() {
                  return _SettingLine(
                      onTap: () async {
                        AppUtil.checkUpdate(context, showLoading: true);
                      },
                      title: S.of(context).s_check_update,
                      value: logic.versionName.value);
                }),
              ],
            ),
          ),
          if (!StoreLogic.isLogin)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 44),
              child: StoreLogic.isLogin
                  ? FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).dividerTheme.color),
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
            onTap: () => AppUtil.changeTheme(!(StoreLogic.to.isDarkMode)),
            child: Stack(
              children: [
                AnimatedContainer(
                  width: 40,
                  height: 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: StoreLogic.to.isDarkMode
                          ? const Color(0xffA1A7BB)
                          : Styles.cMain),
                  duration: const Duration(milliseconds: 200),
                ),
                AnimatedPositioned(
                    left: StoreLogic.to.isDarkMode ? 0 : 20,
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
                          child: StoreLogic.to.isDarkMode
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
          const Gap(10),
          InkWell(
            onTap: () async {
              await Loading.wrap(() async {
                await Apis().logout(header: StoreLogic.to.loginUserInfo?.token);
                await StoreLogic.clearUserInfo();
              });
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Expanded(child: Text(S.of(context).s_exit_login)),
                  const CupertinoListTileChevron(),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              Loading.wrap(() async {
                await Apis()
                    .sendCode(AppUtil.decodeBase64(StoreLogic.to.loginUsername),
                        'logOff')
                    .whenComplete(() {
                  Get.back();
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => const _DeleteAccountInputDialog(),
                  );
                });
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Expanded(child: Text(S.of(context).s_deleteAccount)),
                  const CupertinoListTileChevron(),
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
                  await Apis().deleteAccount(
                      AppUtil.decodeBase64(StoreLogic.to.loginUsername),
                      pwdCtrl.text,
                      verifyCodeCtrl.text);
                  Get.back();
                  StoreLogic.clearUserInfo();
                },
                child: Text(S.of(context).s_ok)),
          ),
          Gap(max(MediaQuery.of(context).viewInsets.bottom,
                  MediaQuery.of(context).padding.bottom) +
              20)
        ],
      ),
    );
  }
}
