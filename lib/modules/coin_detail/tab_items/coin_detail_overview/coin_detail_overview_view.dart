import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_overview/widget/_tip_dialog.dart';
import 'package:ank_app/widget/animated_color_text.dart';
import 'package:ank_app/widget/rate_with_sign.dart';
import 'package:collection/collection.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../res/export.dart';
import 'coin_detail_overview_logic.dart';
import 'widget/_data_grid_view.dart';

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
    return SingleChildScrollView(
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Obx(() {
                      var coinInfo = logic.detailLogic.contractLogic.state.data
                          .where((p0) => p0.baseCoin == logic.baseCoin)
                          .first;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedColorText(
                            text: '\$${coinInfo.price}',
                            value: coinInfo.price ?? 0,
                            style: TextStyle(
                                fontWeight: Styles.fontMedium, fontSize: 18),
                          ),
                          RateWithSign(rate: coinInfo.priceChangeH24),
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
            //todo intl
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 4),
              child: Text(
                '基本信息',
                style: Styles.tsBody_16m(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  _row(
                      title: '历史最高',
                      value: detail.value?.marketData?.ath?.usd,
                      showDollar: true),
                  _row(
                      title: '历史最低',
                      value: detail.value?.marketData?.atl?.usd,
                      showDollar: true),
                  _row(
                    title: '流通市值',
                    value: detail.value?.marketData?.marketCap?.usd,
                    showDollar: true,
                    hintText:
                        '市值 = 当前价格 x 流通供应量\n\n代币了加密货币流通供应的总市值。它类似于股票市场对每股价格乘以市场上现有股票所进行的计算（非内部人员、政府持有及锁定）',
                  ),
                  _row(
                    title: '流通供应量',
                    value: detail.value?.marketData?.circulatingSupply,
                    hintText:
                        '在市场中流通且可供公众交易的代币数量。其类似于如何看待市场中的股票（非内部人员、政府持有及锁定）。',
                  ),
                  _row(
                    title: '24H 交易量',
                    value: detail.value?.marketData?.totalVolume?.usd,
                    showDollar: true,
                    hintText:
                        '衡量过去 24 小时内所有跟踪平台的加密货币成交量。这是在 24 小时滚动的基础上进行跟踪的，没有开市和收市时间。',
                  ),
                  _row(
                    title: '总供应量',
                    value: detail.value?.marketData?.totalSupply,
                    showDollar: true,
                    hintText:
                        '已经创建的代币总量，减去任何已经消耗的代币（退出流通）。这与股票市场中的流通股类似。\n\n总供应量 = 链内供应 - 已消耗代币',
                  ),
                  _row(
                    title: '完全摊薄市值',
                    value: detail.value?.marketData?.fullyDilutedValuation?.usd,
                    showDollar: true,
                    hintText:
                        '衡量过去 24 小时内所有跟踪平台的加密货币成交量。这是在 24 小时滚动的基础上进行跟踪的，没有开市和收市时间。',
                  ),
                  //                            priceChangeTodayDesc: '<strong>{coinName}</strong>({symbol}) 今天的价格是 <strong>{priceCurrent}</strong>, 24小时交易量为 <strong>{tradeVol24}</strong>。\n 价格在过去24小时内 {upOrDown} <strong>{priceChange}</strong>。货币流通量为 <strong>{circulatingSupply}</strong>, 最大供应量为 <strong>{maxSupply}</strong>。<a href="https://accounts.binance.com/zh-CN/register?ref=MLMH46UO" target="_blank">Binance</a> 是当前交易最活跃的市场。',
                  _row(
                    title: '最大供应量',
                    value: detail.value?.marketData?.maxSupply,
                    showDollar: true,
                    hintText:
                        '加密货币终身可能存在的编码代币最大数量。这与股票市场中的最大发行股票类似。\n\n最大供应量 = 编码的理论最大值',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '简介',
                                style: Styles.tsSub_14(context),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 15,
                            child: Builder(builder: (context) {
                              var description = detail.value?.description
                                      ?.toJson()[AppUtil.shortLanguageName]
                                      .toString() ??
                                  '';
                              var en = detail.value?.description
                                      ?.toJson()['en']
                                      ?.toString() ??
                                  '';
                              return ExpandableText(
                                description.isEmpty ? en : description,
                                collapseOnTextTap: true,
                                expandText: '展开',
                                collapseText: '收起',
                                maxLines: 6,
                                linkStyle: Styles.tsMain_12,
                              );
                            })),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Gap(10),
            Divider(
                height: 8, thickness: 8, color: Theme.of(context).cardColor),
            Padding(
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Text(
                  '相关链接',
                  style: Styles.tsBody_16m(context),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  if (detail.value?.links?.homepage?.isNotEmpty == true)
                    _siteGroup(
                      title: '官网',
                      sites: detail.value?.links?.homepage,
                    ),
                  if (detail.value?.links?.blockchainSite?.isNotEmpty == true)
                    _siteGroup(
                      title: '浏览器',
                      sites: detail.value?.links?.blockchainSite,
                    ),
                  if (detail.value?.links?.subredditUrl?.isNotEmpty == true ||
                      detail.value?.links?.officialForumUrl?.isNotEmpty ==
                          true ||
                      detail.value?.links?.chatUrl?.isNotEmpty == true ||
                      detail.value?.links?.announcementUrl?.isNotEmpty ==
                          true ||
                      detail.value?.links?.twitterScreenName?.isNotEmpty ==
                          true ||
                      detail.value?.links?.facebookUsername?.isNotEmpty ==
                          true ||
                      detail.value?.links?.telegramChannelIdentifier
                              ?.isNotEmpty ==
                          true)
                    _siteGroup(title: '社区', sites: [
                      detail.value?.links?.subredditUrl ?? '',
                      if (detail.value?.links?.twitterScreenName?.isNotEmpty ==
                          true)
                        'https://twitter.com/${detail.value?.links?.twitterScreenName ?? ''}',
                      if (detail.value?.links?.facebookUsername?.isNotEmpty ==
                          true)
                        'https://www.facebook.com/${detail.value?.links?.facebookUsername ?? ''}',
                      if (detail.value?.links?.telegramChannelIdentifier
                              ?.isNotEmpty ==
                          true)
                        'https://t.me/${detail.value?.links?.telegramChannelIdentifier ?? ''}',
                      ...detail.value?.links?.officialForumUrl ?? [],
                      ...detail.value?.links?.chatUrl ?? [],
                      ...detail.value?.links?.announcementUrl ?? [],
                    ]),
                  if (detail.value?.links?.reposUrl?.github?.isNotEmpty ==
                          true ||
                      detail.value?.links?.reposUrl?.bitbucket?.isNotEmpty ==
                          true)
                    _siteGroup(title: '源码', sites: [
                      detail.value?.links?.reposUrl?.github?.firstOrNull ?? '',
                      detail.value?.links?.reposUrl?.bitbucket?.firstOrNull ??
                          '',
                    ]),
                  const Divider(height: 20),
                  if (detail.value?.categories?.isNotEmpty == true)
                    _siteGroup(
                        title: '分类',
                        sites: detail.value?.categories,
                        isTag: true),
                ],
              ),
            ),
            const Gap(10),
            Divider(
                height: 8, thickness: 8, color: Theme.of(context).cardColor),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: Text(
                '市值排行榜',
                style: Styles.tsBody_16m(context),
              ),
            ),
            DataGridView(logic: logic)
          ],
        );
      }),
    );
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
        .map((e) => Uri.parse(e))
        .toList();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 58,
            child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    title,
                    style: Styles.tsSub_14(context),
                  ),
                ))),
        Expanded(
            child: Wrap(
          children: uris
              .mapIndexed((index, e) => GestureDetector(
                  onTap: () =>
                      launchUrl(e, mode: LaunchMode.externalApplication),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            isTag
                                ? (sites ?? [])[index]
                                : _specialHost[e.host] ?? e.host,
                            style: isTag
                                ? Styles.tsBody_12m(context)
                                : Styles.tsMain_14.medium),
                        if (!isTag && index != uris.length - 1) ...[
                          const Gap(10),
                          Container(width: 1, height: 6, color: Styles.cMain),
                        ]
                      ],
                    ),
                  )))
              .toList(),
        ))
      ],
    );
  }

  final formatter = NumberFormat('#,##0', 'en_US');

  Widget _row(
      {required String title,
      required double? value,
      bool showDollar = false,
      String? hintText}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Styles.tsSub_14(context),
                ),
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
                      padding: EdgeInsets.only(left: 2),
                      child: Icon(CupertinoIcons.question_circle, size: 14),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
              flex: 15,
              child: Text(
                ('${showDollar ? '\$' : ''}${formatter.format(value ?? 0)}'),
                style: Styles.tsBody_14(context),
              )),
        ],
      ),
    );
  }
}
