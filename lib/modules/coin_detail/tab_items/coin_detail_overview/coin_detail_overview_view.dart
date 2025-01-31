import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_overview/coin_detail_overview_logic.dart';
import 'package:ank_app/modules/coin_detail/widgets/coin_detail_tip_dialog.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/animated_color_text.dart';
import 'package:ank_app/widget/rate_with_sign.dart';
import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CoinDetailOverviewView extends StatefulWidget {
  const CoinDetailOverviewView({super.key});

  @override
  State<CoinDetailOverviewView> createState() => _CoinDetailOverviewViewState();
}

class _CoinDetailOverviewViewState extends State<CoinDetailOverviewView> {
  final logic = Get.put(CoinDetailOverviewLogic());

  @override
  Widget build(BuildContext context) {
    final detail = logic.coinDetail;
    return Obx(() {
      return ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Obx(() {
                    final coinInfo = logic.coin24hInfo.value;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedColorText(
                          text: '\$${coinInfo?.lastPrice ?? 0}',
                          value: coinInfo?.lastPrice ?? 0,
                          style: TextStyle(
                              fontWeight: Styles.fontMedium, fontSize: 18),
                        ),
                        RateWithSign(rate: coinInfo?.priceChange24h),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).cardColor,
            height: 8,
            thickness: 8,
          ),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 4),
            child: Text(
              S.of(context).basicInfo,
              style: Styles.tsBody_16m(context),
            ),
          ),
          _row(
              title: S.of(context).allTimeHigh,
              value: detail.value?.marketData?.ath?.usd,
              showDollar: true,
              needFormat: false),
          _row(
              title: S.of(context).allTimeLow,
              value: detail.value?.marketData?.atl?.usd,
              showDollar: true,
              needFormat: false),
          _row(
            title: S.of(context).marketCap,
            value: detail.value?.marketData?.marketCap?.usd,
            showDollar: true,
            largeNum: true,
            hintText: S.of(context).marketCapIntro,
          ),
          _row(
            title: S.of(context).circulatingSupply,
            value: detail.value?.marketData?.circulatingSupply,
            hintText: S.of(context).circulatingSupplyIntro,
          ),
          _row(
            title: '24H ${S.of(context).totalVolume}',
            value: detail.value?.marketData?.totalVolume?.usd,
            showDollar: true,
            largeNum: true,
            hintText: S.of(context).totalVolume24hIntro,
          ),
          _row(
            title: S.of(context).totalSupply,
            value: detail.value?.marketData?.totalSupply,
            showDollar: true,
            hintText: S.of(context).totalSupplyIntro,
          ),
          _row(
            title: S.of(context).fullyDilutedValuation,
            value: detail.value?.marketData?.fullyDilutedValuation?.usd,
            showDollar: true,
            largeNum: true,
            hintText: S.of(context).fullyDilutedValuationIntro,
          ),
          _row(
            title: S.of(context).maxSupply,
            value: detail.value?.marketData?.maxSupply,
            showDollar: true,
            hintText: S.of(context).maxSupplyIntro,
          ),
          const Gap(10),
          Divider(height: 8, thickness: 8, color: Theme.of(context).cardColor),
          Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: Text(
                S.of(context).relatedLinks,
                style: Styles.tsBody_16m(context),
              )),
          if (detail.value?.links?.homepage?.isNotEmpty == true)
            _siteGroup(
              title: S.of(context).officialWebsite,
              sites: detail.value?.links?.homepage,
            ),
          if (detail.value?.links?.blockchainSite?.isNotEmpty == true)
            _siteGroup(
              title: S.of(context).explorers,
              sites: detail.value?.links?.blockchainSite,
            ),
          if (detail.value?.links?.subredditUrl?.isNotEmpty == true ||
              detail.value?.links?.officialForumUrl?.isNotEmpty == true ||
              detail.value?.links?.chatUrl?.isNotEmpty == true ||
              detail.value?.links?.announcementUrl?.isNotEmpty == true ||
              detail.value?.links?.twitterScreenName?.isNotEmpty == true ||
              detail.value?.links?.facebookUsername?.isNotEmpty == true ||
              detail.value?.links?.telegramChannelIdentifier?.isNotEmpty ==
                  true)
            _siteGroup(title: S.of(context).community, sites: [
              detail.value?.links?.subredditUrl ?? '',
              if (detail.value?.links?.twitterScreenName?.isNotEmpty == true)
                'https://twitter.com/${detail.value?.links?.twitterScreenName ?? ''}',
              if (detail.value?.links?.facebookUsername?.isNotEmpty == true)
                'https://www.facebook.com/${detail.value?.links?.facebookUsername ?? ''}',
              if (detail.value?.links?.telegramChannelIdentifier?.isNotEmpty ==
                  true)
                'https://t.me/${detail.value?.links?.telegramChannelIdentifier ?? ''}',
              ...detail.value?.links?.officialForumUrl ?? [],
              ...detail.value?.links?.chatUrl ?? [],
              ...detail.value?.links?.announcementUrl ?? [],
            ]),
          if (detail.value?.links?.reposUrl?.github?.isNotEmpty == true ||
              detail.value?.links?.reposUrl?.bitbucket?.isNotEmpty == true)
            _siteGroup(title: S.of(context).sourceCode, sites: [
              detail.value?.links?.reposUrl?.github?.firstOrNull ?? '',
              detail.value?.links?.reposUrl?.bitbucket?.firstOrNull ?? '',
            ]),
          const Divider(height: 20),
          if (detail.value?.categories?.isNotEmpty == true)
            _siteGroup(
                title: S.of(context).tags,
                sites: detail.value?.categories,
                isTag: true),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: Text(
              S.of(context).intro,
              style: Styles.tsBody_16m(context),
            ),
          ),
          const Gap(15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Builder(builder: (context) {
              final description = detail.value?.description
                      ?.toJson()[AppUtil.shortLanguageName]
                      .toString() ??
                  '';
              final en =
                  detail.value?.description?.toJson()['en']?.toString() ?? '';
              return ExpandableText(
                (description.isEmpty ? en : description)
                    .replaceAll(RegExp('<[^>]*>'), ''),
                collapseOnTextTap: true,
                expandText: S.of(context).more,
                collapseText: S.of(context).less,
                maxLines: 4,
                linkStyle: Styles.tsMain_12,
              );
            }),
          ),
          const Gap(200),
        ],
      );
    });
  }

  final _specialHost = {
    'www.reddit.com': 'Reddit',
    'twitter.com': 'Twitter',
    'www.facebook.com': 'Facebook',
    't.me': 'Telegram',
    'github.com': 'GitHub',
  };

  Widget _siteGroup(
      {required String title,
      required List<String>? sites,
      bool isTag = false}) {
    final uris = (sites ?? [])
        .where((element) => element.isNotEmpty)
        .map(Uri.parse)
        .toList();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(15),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: Styles.tsSub_14(context),
          ),
        ),
        const Gap(20),
        Expanded(
            child: Wrap(
          alignment: WrapAlignment.end,
          children: uris
              .mapIndexed((index, e) => GestureDetector(
                  onTap: () =>
                      launchUrl(e, mode: LaunchMode.externalApplication),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (index != 0) const Gap(10),
                        Text(
                            isTag
                                ? (sites ?? [])[index]
                                : _specialHost[e.host] ?? e.host,
                            style: isTag
                                ? Styles.tsBody_12m(context)
                                : Styles.tsMain_14.medium),
                      ],
                    ),
                  )))
              .toList(),
        )),
        const Gap(15),
      ],
    );
  }

  final formatter = NumberFormat('#,##0', 'en_US');

  Widget _row(
      {required String title,
      required double? value,
      bool showDollar = false,
      bool needFormat = true,
      bool largeNum = false,
      String? hintText}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Styles.tsSub_14(context),
          ),
          const Gap(3),
          if (hintText != null)
            GestureDetector(
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return TipDialog(
                      title: title,
                      content: hintText,
                    );
                  },
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 2, top: 4),
                child: Icon(CupertinoIcons.question_circle, size: 14),
              ),
            ),
          const Gap(3),
          Expanded(
              flex: 15,
              child: Text(
                '${showDollar ? r'$' : ''}${largeNum ? AppUtil.getLargeFormatString(value, precision: 2) : needFormat ? formatter.format(value ?? 0) : (Decimal.tryParse('$value') ?? 0).toString()}',
                style: Styles.tsBody_14(context),
                textAlign: TextAlign.end,
              )),
        ],
      ),
    );
  }
}
