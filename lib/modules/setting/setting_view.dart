import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/util/app_nav.dart';
import 'package:ank_app/util/app_util.dart';
import 'package:ank_app/util/store.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'setting_logic.dart';

class SettingPage extends StatefulWidget {
  SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final logic = Get.put(SettingLogic());

  final state = Get.find<SettingLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitleBar(title: S.of(context).s_setting),
      backgroundColor: Colors.transparent,
      body: ListView(
        children: [
          const Gap(10),
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
            Widget adaptiveAction(
                {required VoidCallback onPressed, required Widget child}) {
              final ThemeData theme = Theme.of(context);
              switch (theme.platform) {
                case TargetPlatform.android:
                case TargetPlatform.fuchsia:
                case TargetPlatform.linux:
                case TargetPlatform.windows:
                  return TextButton(onPressed: onPressed, child: child);
                case TargetPlatform.iOS:
                case TargetPlatform.macOS:
                  return CupertinoDialogAction(
                      onPressed: onPressed, child: child);
              }
            }

            return _SettingLine(
                onTap: () async {
                  var result =
                      await Loading.wrap(() async => AppUtil.needUpdate());
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
                            adaptiveAction(
                                child: Text(S.of(context).s_cancel),
                                onPressed: () {
                                  Get.back();
                                }),
                            adaptiveAction(
                                child: Text(S.of(context).s_ok),
                                onPressed: () async {
                                  await launchUrl(Uri.parse(result.jumpUrl),
                                      mode: LaunchMode.externalApplication);
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
