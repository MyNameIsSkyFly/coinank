import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'about_logic.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  static const String routeName = '/about';
  final logic = Get.put(AboutLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitleBar(
        title: S.of(context).aboutCoinank,
      ),
      body: Column(
        children: [
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
