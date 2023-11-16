import 'package:ank_app/generated/assets.dart';
import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/res/styles.dart';
import 'package:ank_app/util/app_util.dart';
import 'package:ank_app/util/image_util.dart';
import 'package:ank_app/widget/rate_with_sign.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../generated/l10n.dart';
import '../../widget/rate_with_arrow.dart';
import 'home_logic.dart';
import 'package:easy_refresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final logic = Get.put(HomeLogic());

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      logic.appVisible = true;
    } else if (state == AppLifecycleState.paused) {
      logic.appVisible = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        leadingWidth: 150,
        centerTitle: false,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              'Coinank',
              style: Styles.tsBody_20(context)
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        actions: [
          IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () {},
              icon: Image.asset(
                Assets.imagesIcSearch,
                height: 20,
                width: 20,
                color: Theme.of(context).iconTheme.color,
              )),
          IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () {},
              icon: Stack(
                children: [
                  Image.asset(
                    Assets.imagesIcBell,
                    height: 20,
                    width: 20,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        height: 4,
                        width: 4,
                        decoration: const BoxDecoration(
                            color: Color(0xffD8494A), shape: BoxShape.circle),
                      ))
                ],
              )),
          const Gap(10),
        ],
      ),
      body: EasyRefresh(
        onRefresh: logic.onRefresh,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TotalOiAndFuturesVol(logic: logic),
              const Gap(10),

              ///清算地图
              _CheckDetailRow(title: S.of(context).s_liqmap, onTap: () {}),
              const Gap(20),
              _HotMarket(logic: logic),
              const Gap(20),
              _OiDistribution(logic: logic),
              const Gap(20),
              _BtcInfo(logic: logic),
              const Gap(10),
              _FearGreedInfo(logic: logic),
              const Gap(10),

              ///灰度数据
              _CheckDetailRow(title: S.of(context).s_grayscale_data)
            ],
          ),
        ),
      ),
    );
  }
}

class _FearGreedInfo extends StatelessWidget {
  const _FearGreedInfo({
    super.key,
    required this.logic,
  });

  final HomeLogic logic;

  @override
  Widget build(BuildContext context) {
    return _OutlinedContainer(
      child: Obx(() {
        return Row(
          children: [
            Text(S.of(context).s_greed_index,
                style: Styles.tsBody_12m(context)),
            const Gap(10),
            Text(
              switch (
                  double.tryParse(logic.homeInfoData.value?.cnnValue ?? '') ??
                      -1) {
                >= 0 && <= 25 => S.of(context).s_extreme_fear,
                > 25 && <= 50 => S.of(context).s_fear,
                > 50 && <= 75 => S.of(context).s_greed,
                > 75 && <= 100 => S.of(context).s_extreme_greed,
                _ => '',
              },
              style: TextStyle(
                  fontSize: 12,
                  color: switch (double.tryParse(
                          logic.homeInfoData.value?.cnnValue ?? '') ??
                      -1) {
                    <= 50 => Styles.cDown(context),
                    _ => Styles.cUp(context),
                  }),
            ),
            const Spacer(),
            Text(
              (double.tryParse(logic.homeInfoData.value?.cnnValue ?? '') ?? 0)
                  .toStringAsFixed(0),
              style: Styles.tsBody_12m(context),
            ),
            const Gap(7),
            RateWithArrow(
                rate: (double.tryParse(
                            logic.homeInfoData.value?.cnnChange ?? '') ??
                        0) *
                    100)
          ],
        );
      }),
    );
  }
}

///btc市值占比+投资回报率
class _BtcInfo extends StatelessWidget {
  const _BtcInfo({
    super.key,
    required this.logic,
  });

  final HomeLogic logic;

  @override
  Widget build(BuildContext context) {
    return _OutlinedContainer(
      child: Obx(() {
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        Assets.imagesIcCoinBtc,
                        height: 18,
                        width: 18,
                      ),
                      const Gap(5),
                      Text(
                        S.of(context).s_marketcap_ratio,
                        style: Styles.tsBody_12m(context),
                      ),
                      const Icon(CupertinoIcons.chevron_right, size: 12),
                    ],
                  ),
                  const Gap(6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${((double.tryParse(logic.homeInfoData.value?.marketCpaValue ?? '') ?? 0) * 100).toStringAsFixed(2)}%',
                        style: Styles.tsMain_18
                            .copyWith(fontWeight: FontWeight.w600, height: 1),
                      ),
                      const Gap(5),
                      RateWithArrow(
                          rate: (double.tryParse(logic.homeInfoData.value
                                          ?.marketCpaChange ??
                                      '') ??
                                  0) *
                              100),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30, child: VerticalDivider()),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          Assets.imagesIcCoinBtc,
                          height: 18,
                          width: 18,
                        ),
                        const Gap(5),
                        Text(
                          S.of(context).s_btc_profit,
                          style: Styles.tsBody_12m(context),
                        ),
                        const Icon(CupertinoIcons.chevron_right, size: 12),
                      ],
                    ),
                    const Gap(6),
                    Text(
                      '${((double.tryParse(logic.homeInfoData.value?.btcProfit ?? '') ?? 0)).toStringAsFixed(2)}%',
                      style: Styles.tsMain_18
                          .copyWith(fontWeight: FontWeight.w600, height: 1),
                    )
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}

///持仓分布
class _OiDistribution extends StatelessWidget {
  const _OiDistribution({
    super.key,
    required this.logic,
  });

  final HomeLogic logic;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(S.of(context).oiDistribution,
                      style: Styles.tsBody_16m(context))),
              _FilledContainer(
                onTap: () {},
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      S.of(context).s_buysel_longshort_ratio,
                      style: Styles.tsBody_12m(context),
                    ),
                    const Gap(7),
                    //todo 换成接口数据
                    Text(
                      logic.buySellLongShortRatio,
                      style: Styles.tsMain_14m
                          .copyWith(decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Gap(15),

          ///多空持仓人数比
          _LongShortRatio(
              title: S.of(context).s_bn_longshort_person_ratio,
              long: double.parse(
                  logic.homeInfoData.value?.binancePersonValue ?? '0'),
              // short: 9,
              rate: double.parse(
                  logic.homeInfoData.value?.binancePersonChange ?? '0')),
          const Gap(10),
          _LongShortRatio(
              title: S.of(context).s_ok_longshort_person_ratio,
              long: double.parse(
                  logic.homeInfoData.value?.okexPersonValue ?? '0'),
              rate: double.parse(
                  logic.homeInfoData.value?.okexPersonChange ?? '0')),
        ],
      );
    });
  }
}

///热门行情
class _HotMarket extends StatelessWidget {
  const _HotMarket({
    super.key,
    required this.logic,
  });

  final HomeLogic logic;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).hotMarket,
            style: Styles.tsBody_16m(context),
          ),
          const Gap(15),
          Row(
            children: [
              Expanded(
                child: _OutlinedContainer(
                  child: Obx(() {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              S.of(context).s_oi_chg,
                              style: Styles.tsBody_12m(context),
                            ),
                            Text(
                              ' (24H)',
                              style: Styles.tsBody_12m(context),
                            ),
                          ],
                        ),
                        ...List.generate(
                          3,
                          (index) => _DataWithIcon(
                              title: logic.oiList?[index].baseCoin ?? '',
                              icon: logic.oiList?[index].coinImage ?? '',
                              value: logic.oiList?[index].priceChangeH24 ?? 0),
                        )
                      ],
                    );
                  }),
                ),
              ),
              const Gap(9),
              Expanded(
                child: _OutlinedContainer(
                  child: Obx(() {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              S.of(context).s_price_chg,
                              style: Styles.tsBody_12m(context),
                            ),
                            Text(
                              ' (24H)',
                              style: Styles.tsBody_12m(context),
                            ),
                          ],
                        ),
                        ...List.generate(
                          3,
                          (index) => _DataWithIcon(
                              title: logic.priceList?[index].baseCoin ?? '',
                              icon: logic.priceList?[index].coinImage ?? '',
                              value:
                                  logic.priceList?[index].priceChangeH24 ?? 0),
                        )
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
          const Gap(10),

          ///爆仓数据
          Row(
            children: [
              Expanded(
                child: _OutlinedContainer(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            S.of(context).s_liquidation_data,
                            style: Styles.tsBody_12m(context),
                          ),
                          Text(
                            ' (24H)',
                            style: Styles.tsBody_12m(context),
                          ),
                        ],
                      ),
                      _DataWithQuantity(
                          title: '24H',
                          value: AppUtil.getLargeFormatString(
                              logic.homeInfoData.value?.liquidation ?? '0'),
                          isLong: true),
                      _DataWithQuantity(
                          title: S.of(context).s_longs,
                          value: AppUtil.getLargeFormatString(
                              logic.homeInfoData.value?.liquidationLong ?? '0'),
                          isLong: true),
                      _DataWithQuantity(
                          title: S.of(context).s_shorts,
                          value: AppUtil.getLargeFormatString(
                              logic.homeInfoData.value?.liquidationShort ??
                                  '0'),
                          isLong: false),
                    ],
                  ),
                ),
              ),
              const Gap(9),
              Expanded(
                child: _OutlinedContainer(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            S.of(context).s_funding_rate,
                            style: Styles.tsBody_12m(context),
                          ),
                          Text(
                            ' (24H)',
                            style: Styles.tsBody_12m(context),
                          ),
                        ],
                      ),
                      //todo 换成接口数据
                      ...List.generate(
                        3,
                        (index) {
                          if (logic.fundRateList.isEmpty) {
                            return const _DataWithoutIcon(title: '', value: 0);
                          }
                          var item = logic.fundRateList[index];
                          return _DataWithoutIcon(
                              title: item.symbol ?? '',
                              value: item.fundingRate ?? 0);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

///合约总持仓+合约成交量
class _TotalOiAndFuturesVol extends StatelessWidget {
  const _TotalOiAndFuturesVol({
    super.key,
    required this.logic,
  });

  final HomeLogic logic;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          _FirstLineItem(
            title: S.of(context).s_total_oi,
            value: AppUtil.getLargeFormatString(
                logic.homeInfoData.value?.openInterest ?? '0'),
            rate:
                double.tryParse(logic.homeInfoData.value?.oiChange ?? '0') ?? 0,
          ),
          const Gap(9),
          _FirstLineItem(
              title: S.of(context).s_futures_vol_24h,
              rate: double.tryParse(
                      logic.homeInfoData.value?.tickerChange ?? '0') ??
                  0,
              value: AppUtil.getLargeFormatString(
                  logic.homeInfoData.value?.ticker ?? '0')),
        ],
      );
    });
  }
}

class _CheckDetailRow extends StatelessWidget {
  const _CheckDetailRow({
    super.key,
    required this.title,
    this.onTap,
  });

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _OutlinedContainer(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: Styles.tsBody_12m(context),
            ),
          ),
          Text(
            S.of(context).viewDetail,
            style: Styles.tsSub_12m(context),
          ),
          const Icon(CupertinoIcons.chevron_right, size: 12)
        ],
      ),
    );
  }
}

class _LongShortRatio extends StatelessWidget {
  const _LongShortRatio({
    super.key,
    required this.title,
    required this.long,
    // required this.short,
    required this.rate,
  });

  final String title;
  final double long;

  // final double short;
  final double rate;

  double get actualLong => long / (1 + long);

  double get short => 1 - actualLong;

  @override
  Widget build(BuildContext context) {
    return _FilledContainer(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Styles.tsBody_12m(context),
                ),
              ),
              Text((actualLong / short).toStringAsFixed(2),
                  style: Styles.tsBody_14m(context)),
              const Gap(5),
              //todo 换成接口数据
              RateWithArrow(rate: rate * 100)
            ],
          ),
          const Gap(17),
          SizedBox(
            height: 6,
            child: Row(children: [
              Expanded(
                  flex: (actualLong * 1000).toInt(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Styles.cUp(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
              const Gap(2),
              Expanded(
                  flex: (short * 1000).toInt(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Styles.cDown(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
            ]),
          ),
          const Gap(5),
          Row(
            children: [
              Expanded(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    S.of(context).s_longs,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: Styles.fontMedium,
                        color: Styles.cUp(context)),
                  ),
                  const Gap(5),
                  Text(
                    '${(actualLong * 100).toStringAsFixed(2)}%',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: Styles.fontMedium,
                        color: Styles.cUp(context)),
                  )
                ],
              )),
              Expanded(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    S.of(context).s_shorts,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: Styles.fontMedium,
                        color: Styles.cDown(context)),
                  ),
                  const Gap(5),
                  Text(
                    '${(short * 100).toStringAsFixed(2)}%',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: Styles.fontMedium,
                        color: Styles.cDown(context)),
                  )
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }
}

class _DataWithIcon extends StatelessWidget {
  const _DataWithIcon({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final String icon;
  final String title;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          ImageUtil.networkImage(icon, height: 18, width: 18),
          const Gap(5),
          Expanded(
            child: Text(
              title,
              style: Styles.tsBody_12m(context),
            ),
          ),
          RateWithSign(rate: value),
        ],
      ),
    );
  }
}

class _DataWithoutIcon extends StatelessWidget {
  const _DataWithoutIcon({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Styles.tsBody_12m(context),
            ),
          ),
          RateWithSign(rate: value * 100, precision: 4),
        ],
      ),
    );
  }
}

class _DataWithQuantity extends StatelessWidget {
  const _DataWithQuantity({
    super.key,
    required this.title,
    required this.value,
    this.isLong,
  });

  final String title;
  final String value;
  final bool? isLong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Styles.tsBody_12m(context),
            ),
          ),
          Text(
            value,
            style: Styles.tsBody_12m(context).copyWith(
                color: switch (isLong) {
              true => Styles.cUp(context),
              false => Styles.cDown(context),
              null => null,
            }),
          ),
        ],
      ),
    );
  }
}

class _FirstLineItem extends StatelessWidget {
  const _FirstLineItem({
    required this.title,
    required this.value,
    this.rate,
  });

  final String title;
  final String value;
  final double? rate;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _OutlinedContainer(
        onTap: () => MessageHostApi().toTotalOi(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
            const Gap(5),
            Row(
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.tsBody_12m(context),
                ),
                const Gap(5),
                RateWithArrow(rate: (rate ?? 0) * 100),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlinedContainer extends StatelessWidget {
  const _OutlinedContainer({
    super.key,
    this.child,
    this.onTap,
  });

  final Widget? child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: Theme.of(context).dividerTheme.color ?? Colors.white)),
        child: child,
      ),
    );
  }
}

class _FilledContainer extends StatelessWidget {
  const _FilledContainer({super.key, this.child, this.padding, this.onTap});

  final Widget? child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: padding ?? EdgeInsets.all(10),
          child: child,
        ),
      ),
    );
  }
}
