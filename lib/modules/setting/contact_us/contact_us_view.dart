import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_us_logic.dart';

class ContactUsPage extends StatelessWidget {
  ContactUsPage({super.key});

  static const String routeName = '/contact_us';
  final logic = Get.put(ContactUsLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitleBar(
        title: S.of(context).contactUs,
      ),
      body: ListView(
        children: [
          _LinkItem(
              asset: Assets.settingIcPerson,
              title: S.of(context).businessTelegram,
              linkUrl: 'https://t.me/Luukk11',
              linkText: '@Luukk11'),
          _CopyItem(
            asset: Assets.settingIcMail,
            title: S.of(context).businessEmail,
            text: 'business@coinank.com',
          ),
          const Divider(height: 20),
          const _LinkItem(
              asset: Assets.settingIcTelegram,
              title: 'Telegram',
              linkUrl: 'https://t.me/CoinAnkOfficial',
              linkText: '@CoinAnkOfficial'),
          _ArrowItem(
            asset: Assets.settingIcMessage,
            title: S.of(context).telegramGroup,
            onTap: () {
              if (AppUtil.shortLanguageName.contains('zh')) {
                launchUrl(Uri.parse('https://t.me/Coinank_Chinese'),
                    mode: LaunchMode.externalApplication);
              } else {
                launchUrl(Uri.parse('https://t.me/Coinank_Community'),
                    mode: LaunchMode.externalApplication);
              }
            },
          ),
          _ArrowItem(
            asset: Assets.settingIcChannel,
            title: S.of(context).telegramChannel,
            onTap: () {
              if (AppUtil.shortLanguageName.contains('zh')) {
                launchUrl(Uri.parse('https://t.me/CoinankNewsOfficial_CN'),
                    mode: LaunchMode.externalApplication);
              } else {
                launchUrl(Uri.parse('https://t.me/CoinankNews_Official'),
                    mode: LaunchMode.externalApplication);
              }
            },
          ),
          _ArrowItem(
            asset: Assets.settingIcTwitter,
            title: 'Twitter',
            onTap: () {
              if (AppUtil.shortLanguageName.contains('zh')) {
                launchUrl(Uri.parse('https://twitter.com/CoinankCN'),
                    mode: LaunchMode.externalApplication);
              } else {
                launchUrl(Uri.parse('https://twitter.com/coinank_com'),
                    mode: LaunchMode.externalApplication);
              }
            },
          ),
          _ArrowItem(
            asset: Assets.settingIcYoutube,
            title: 'Youtube',
            onTap: () {
              launchUrl(Uri.parse('https://www.youtube.com/@CoinankOfficial'),
                  mode: LaunchMode.externalApplication);
            },
          ),
          const Divider(height: 20),
          _CopyItem(
              asset: Assets.settingIcCustomerService,
              title: S.of(context).customerServiceEmail,
              text: 'support@coinank.com'),
          const Divider(height: 20),
          _LinkItem(
              asset: Assets.settingIcWebsite,
              title: S.of(context).officialWebsite,
              linkUrl: 'https://www.coinank.com',
              linkText: 'www.coinank.com'),
          _ArrowItem(
            asset: Assets.settingIcAbout,
            title: S.of(context).aboutCoinank,
            onTap: () => AppNav.toAbout(),
          ),
        ],
      ),
    );
  }
}

class _LinkItem extends StatelessWidget {
  const _LinkItem(
      {super.key,
      required this.asset,
      required this.title,
      required this.linkUrl,
      required this.linkText});

  final String asset;
  final String title;
  final String linkUrl;
  final String linkText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      child: Row(
        children: [
          Image.asset(asset,
              width: 20, height: 20, color: Theme.of(context).iconTheme.color),
          const Gap(10),
          Expanded(child: Text(title, style: Styles.tsBody_14(context))),
          GestureDetector(
              onTap: () {
                launchUrl(Uri.parse(linkUrl),
                    mode: LaunchMode.externalApplication);
              },
              child: Text(linkText, style: Styles.tsMain_14)),
        ],
      ),
    );
  }
}

class _CopyItem extends StatelessWidget {
  const _CopyItem(
      {super.key,
      required this.asset,
      required this.title,
      required this.text});

  final String asset;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      child: Row(
        children: [
          Image.asset(asset,
              width: 20, height: 20, color: Theme.of(context).iconTheme.color),
          const Gap(10),
          Expanded(child: Text(title, style: Styles.tsBody_14(context))),
          GestureDetector(
              onTap: () => AppUtil.copy(text),
              child: Row(
                children: [
                  Text(text, style: Styles.tsSub_14(context)),
                  const Gap(5),
                  Image.asset(Assets.commonIcCopy, height: 15, width: 15)
                ],
              )),
        ],
      ),
    );
  }
}

class _ArrowItem extends StatelessWidget {
  const _ArrowItem(
      {super.key, required this.asset, required this.title, this.onTap});

  final String asset;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        child: Row(
          children: [
            Image.asset(asset,
                width: 20,
                height: 20,
                color: Theme.of(context).iconTheme.color),
            const Gap(10),
            Expanded(child: Text(title, style: Styles.tsBody_14(context))),
            const Icon(Icons.keyboard_arrow_right_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
