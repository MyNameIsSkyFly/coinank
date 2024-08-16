import 'dart:io';
import 'dart:math';

import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/entity/news_entity.dart';
import 'package:ank_app/modules/chart/chart_view.dart';
import 'package:ank_app/modules/home/home_search/home_search_view.dart';
import 'package:ank_app/modules/home/liq_main/liq_main_view.dart';
import 'package:ank_app/modules/home/price_change/price_change_view.dart';
import 'package:ank_app/modules/home/widgets/btc_reduce_dialog.dart';
import 'package:ank_app/modules/home/widgets/dash_board_painter.dart';
import 'package:ank_app/modules/home/widgets/trapezium_painter.dart';
import 'package:ank_app/modules/news/widget/news_item.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/app_refresh.dart';
import 'package:ank_app/widget/rate_with_sign.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../entity/chart_entity.dart';
import '../../widget/rate_with_arrow.dart';
import '../alert/record/alert_record_view.dart';
import '../chart/chart_logic.dart';
import 'home_logic.dart';
import 'long_short_ratio/long_short_person_ratio/long_short_person_ratio_view.dart';
import 'long_short_ratio/long_short_ratio_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(HomeLogic());
  var canQuit = false;

  @override
  void initState() {
    logic.tabCtrl = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    logic.tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        leadingWidth: double.infinity,
        centerTitle: false,
        leading: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelStyle: Styles.tsBody_18m(context),
            unselectedLabelStyle: Styles.tsSub_18(context).medium,
            indicatorColor: Colors.transparent,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: S.of(context).market),
              Tab(text: S.of(context).s_chart)
            ],
            controller: logic.tabCtrl),
        actions: [
          IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => Get.toNamed(HomeSearchPage.routeName),
              icon: Image.asset(
                Assets.imagesIcSearch,
                height: 20,
                width: 20,
                color: Theme.of(context).iconTheme.color,
              )),
          IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => StoreLogic.isLogin
                  ? Get.toNamed(AlertRecordPage.routeName)
                  : AppNav.toLogin(),
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
                            color: Color(0xffEF424A), shape: BoxShape.circle),
                      ))
                ],
              )),
          const Gap(10),
        ],
      ),
      body: TabBarView(
        controller: logic.tabCtrl,
        children: [_tabMarket(), _tabChart()],
      ),
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (kIsWeb || !Platform.isAndroid) return;
        if (!canQuit) {
          canQuit = true;
          AppUtil.showToast(S.of(context).tapAgainToExit);
          Future.delayed(const Duration(seconds: 2), () {
            canQuit = false;
          });
          return;
        } else {
          SystemNavigator.pop();
        }
      },
      child: child,
    );
  }

  Widget _tabMarket() {
    return AliveWidget(
      child: AppRefresh(
        onRefresh: logic.onRefresh,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: [
            _TotalOiAndFuturesVol(logic: logic),
            const _ChartView(),
            _BtcReduceView(logic: logic),
            _HotMarket(logic: logic),
            _OiDistribution(logic: logic),
            _FearGreedInfo(logic: logic),
            _News(logic: logic),

            //灰度数据
            // _CheckDetailRow(
            //   title: S.of(context).s_grayscale_data,
            //   onTap: () => AppNav.openWebUrl(
            //       title: S.of(context).s_grayscale_data,
            //       url: Urls.urlGrayscale,
            //       showLoading: true),
            // )
          ],
        ),
      ),
    );
  }

  Widget _tabChart() => const AliveWidget(child: ChartPage());
}

class _News extends StatelessWidget {
  const _News({
    required this.logic,
  });

  final HomeLogic logic;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          if (logic.newsList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
              child: Row(
                children: [
                  Text(
                    S.of(context).recommend,
                    style: Styles.tsBody_16m(context),
                  ),
                  if (AppUtil.shortLanguageName == 'en') const Gap(3),
                  Text(
                    S.of(context).news,
                    style: Styles.tsBody_16m(context)
                        .copyWith(color: const Color(0xffEF424A)),
                  ),
                ],
              ),
            ),
          ...logic.newsList.map((e) => NewsItem(e, type: NewsType.recommend)),
          if (logic.newsList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(15),
              child: FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).inputDecorationTheme.fillColor),
                onPressed: () => logic.mainLogic.selectedIndex.value = 3,
                child: Text(S.of(context).viewMore,
                    style: Styles.tsBody_16(context)),
              ),
            )
        ],
      );
    });
  }
}

class _BtcReduceView extends StatelessWidget {
  const _BtcReduceView({
    required this.logic,
  });

  final HomeLogic logic;

  Widget _box(BuildContext context, {required String text}) {
    return Container(
      height: 30,
      width: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).scaffoldBackgroundColor),
      margin: const EdgeInsets.only(left: 8, right: 4),
      child: Text(
        text,
        style: Styles.tsBody_14m(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (logic.hideBtcReduce) return const SizedBox();
    return GestureDetector(
      onTap: () => showCupertinoDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => BtcReduceDialog(logic: logic)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x1aF7931A),
              Color(0x00000000),
            ],
          ),
        ),
        child: Row(
          children: [
            ImageUtil.networkImage(AppConst.imageHost('BTC'),
                width: 18, height: 18),
            const Gap(4),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(S.of(context).btcReduceCountDown,
                      style: Styles.tsBody_14m(context)),
                ),
              ),
            ),
            Obx(() {
              final time = DateTime.fromMillisecondsSinceEpoch(
                  logic.btcReduceData.value?.halvingTime ??
                      DateTime.now().millisecondsSinceEpoch);
              final duration = time.difference(DateTime.now());
              final style1 = TextStyle(
                  color: Styles.cBody(context).withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w500);
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _box(context, text: '${max(duration.inDays, 0)}'),
                  Text(S.of(context).days, style: style1),
                  _box(context,
                      text: '${max(duration.inHours.remainder(24), 0)}'),
                  Text(S.of(context).hours, style: style1),
                  _box(context,
                      text: '${max(duration.inMinutes.remainder(60), 0)}'),
                  Text(S.of(context).minutes, style: style1),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}

class _ChartView extends StatelessWidget {
  const _ChartView();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final chartItems = [
        ChartEntity(
            title: S.of(context).fundFlow,
            key: 'brc-20',
            path: '/${Urls.webLanguage}fund/fundSwap?productType=SWAP'),
        ChartEntity(
            title: S.of(context).aggregatedOrderbookDiff,
            key: 'erc-20',
            path: '/${Urls.webLanguage}indexdata/exchangeAggDepth'),
        ChartEntity(
            title: S.of(context).visualScreener,
            key: 'arc-20',
            path: '/${Urls.webLanguage}indexdata/VisualMap'),
        ChartEntity(
            title: 'ETF',
            key: 'ETF',
            path: '/${Urls.webLanguage}etf/BtcEtfTable'),
        ChartEntity(title: S.of(context).s_liqmap, key: 'liqMapChart'),
        ChartEntity(title: S.of(context).s_liq_hot_map, key: 'liqHeatMapChart'),
        ChartEntity(
            title: S.of(context).fundingRateHeatMap,
            key: 'frHeapMap',
            path: '/${Urls.webLanguage}fundingRate/frHeatMap'),
        ChartEntity(title: S.of(context).more, key: 'more'),
      ];
      final chartLogic = Get.put(ChartLogic());
      final allData = [
        ...chartLogic.state.dataMap['hotData'] ?? [],
        ...chartLogic.state.dataMap['btcData'] ?? [],
        ...chartLogic.state.dataMap['otherData'] ?? [],
      ];
      if (allData.isNotEmpty) {
        try {
          chartItems[3] = allData.firstWhere((element) => element.key == 'ETF');
          chartItems[4] =
              allData.firstWhere((element) => element.key == 'liqMapChart');
          chartItems[5] =
              allData.firstWhere((element) => element.key == 'liqHeatMapChart');
          chartItems[6] =
              allData.firstWhere((element) => element.key == 'frHeapMap');
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      return GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 5),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: 50,
          mainAxisSpacing: 18,
        ),
        itemCount: chartItems.length,
        itemBuilder: (context, index) {
          return _ChartItem(item: chartItems[index]);
        },
      );
    });
  }
}

class _FearGreedInfo extends StatelessWidget {
  const _FearGreedInfo({
    required this.logic,
  });

  final HomeLogic logic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).s_greed_index, style: Styles.tsBody_16m(context)),
          GestureDetector(
            onTap: () => AppNav.openWebUrl(
                title: S.of(context).s_greed_index,
                url: Urls.urlGreedIndex,
                showLoading: true),
            child: Obx(() {
              final degree =
                  double.tryParse(logic.homeInfoData.value?.cnnValue ?? '') ??
                      -1;
              return Container(
                margin: const EdgeInsets.only(top: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          Theme.of(context).dividerTheme.color ?? Colors.white),
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0, 0.5],
                    colors: degree <= 50
                        ? const [
                            Color(0x1af17077),
                            Color(0x00000000),
                          ]
                        : const [
                            Color(0x1a1DCA88),
                            Color(0x00000000),
                          ],
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          switch (degree) {
                            >= 0 && <= 25 => S.of(context).s_extreme_fear,
                            > 25 && <= 50 => S.of(context).s_fear,
                            > 50 && <= 75 => S.of(context).s_greed,
                            > 75 && <= 100 => S.of(context).s_extreme_greed,
                            _ => '',
                          },
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: switch (degree) {
                                <= 50 => Styles.cDown(context),
                                _ => Styles.cUp(context),
                              }),
                        ),
                        const Gap(7),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            children: [
                              Text(
                                (double.tryParse(logic
                                                .homeInfoData.value?.cnnValue ??
                                            '') ??
                                        0)
                                    .toStringAsFixed(0),
                                style: Styles.tsBody_14m(context),
                              ),
                              const Gap(7),
                              RateWithArrow(
                                  rate: (double.tryParse(logic.homeInfoData
                                                  .value?.cnnChange ??
                                              '') ??
                                          0) *
                                      100)
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            S.of(context).s_fear,
                            style: TextStyle(
                                    color: Styles.cDown(context), fontSize: 12)
                                .medium,
                          ),
                          CustomPaint(
                            size: const Size(130, 60),
                            painter: DashBoardPainter(
                                Styles.cUp(context), Styles.cDown(context),
                                radians: (degree - 50) / 100,
                                isDarkMode: Theme.of(context).brightness ==
                                    Brightness.dark),
                          ),
                          Text(
                            S.of(context).s_greed,
                            style: TextStyle(
                                    color: Styles.cUp(context), fontSize: 12)
                                .medium,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

///持仓分布
class _OiDistribution extends StatelessWidget {
  const _OiDistribution({
    required this.logic,
  });

  final HomeLogic logic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 20),
      child: Obx(() {
        final ratio = double.parse(logic.buySellLongShortRatio);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).s_longshort_ratio,
                style: Styles.tsBody_16m(context)),
            GestureDetector(
              onTap: () => Get.toNamed(LongShortRatioPage.routeName),
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          Theme.of(context).dividerTheme.color ?? Colors.white),
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0, 0.5],
                    colors: ratio < 1
                        ? const [
                            Color(0x1af17077),
                            Color(0x00000000),
                          ]
                        : const [
                            Color(0x1a1DCA88),
                            Color(0x00000000),
                          ],
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                      S.of(context).s_buysel_longshort_ratio,
                                      style: Styles.tsSub_14m(context)),
                                ),
                                const Gap(5),
                                Icon(CupertinoIcons.chevron_right,
                                    color: Styles.cSub(context), size: 10)
                              ],
                            ),
                            const Gap(5),
                            Text(
                              logic.buySellLongShortRatio,
                              style: Styles.tsBody_18m(context).copyWith(
                                  color: ratio >= 1
                                      ? Styles.cUp(context)
                                      : Styles.cDown(context)),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            S.of(context).s_shorts,
                            style: TextStyle(
                                    color: Styles.cDown(context), fontSize: 12)
                                .medium,
                          ),
                          CustomPaint(
                            size: const Size(130, 60),
                            painter: DashBoardPainter(
                                Styles.cUp(context), Styles.cDown(context),
                                radians: (ratio - 1) / 2,
                                isDarkMode: Theme.of(context).brightness ==
                                    Brightness.dark),
                          ),
                          Text(
                            S.of(context).s_longs,
                            style: TextStyle(
                                    color: Styles.cUp(context), fontSize: 12)
                                .medium,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Gap(15),

            ///多空持仓人数比
            _LongShortRatio(
                onTap: () => Get.toNamed(LongShortPersonRatioPage.routeName),
                title: S.of(context).s_bn_longshort_person_ratio,
                long: double.parse(
                    logic.homeInfoData.value?.binancePersonValue ?? '0'),
                // short: 9,
                rate: double.parse(
                    logic.homeInfoData.value?.binancePersonChange ?? '0')),
            const Gap(10),
            _LongShortRatio(
                onTap: () => Get.toNamed(LongShortPersonRatioPage.routeName),
                title: S.of(context).s_ok_longshort_person_ratio,
                long: double.parse(
                    logic.homeInfoData.value?.okexPersonValue ?? '0'),
                rate: double.parse(
                    logic.homeInfoData.value?.okexPersonChange ?? '0')),
          ],
        );
      }),
    );
  }
}

///热门行情
class _HotMarket extends StatelessWidget {
  const _HotMarket({
    required this.logic,
  });

  final HomeLogic logic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            Text(
              S.of(context).hotMarket,
              style: Styles.tsBody_16m(context),
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: _OutlinedContainer(
                    onTap: () => Get.toNamed(PriceChangePage.priceChange,
                        arguments: {'isPrice': false}),
                    child: Obx(() {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      S.of(context).s_oi_chg,
                                      style: Styles.tsSub_14m(context),
                                    ),
                                    Text(
                                      ' (24H)',
                                      style: Styles.tsSub_14m(context),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_right_rounded,
                                  size: 18, color: Styles.cSub(context)),
                            ],
                          ),
                          ...List.generate(
                            3,
                            (index) => _DataWithIcon(
                                title: logic.oiList?[index].baseCoin ?? '',
                                icon: logic.oiList?[index].coinImage ?? '',
                                value: (logic.oiList?[index].openInterestCh24 ??
                                        0) *
                                    100),
                          )
                        ],
                      );
                    }),
                  ),
                ),
                const Gap(9),
                Expanded(
                  child: _OutlinedContainer(
                    onTap: () => Get.toNamed(PriceChangePage.priceChange,
                        arguments: {'isPrice': true}),
                    child: Obx(() {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      S.of(context).s_price_chg,
                                      style: Styles.tsSub_14m(context),
                                    ),
                                    Text(
                                      ' (24H)',
                                      style: Styles.tsSub_14m(context),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_right_rounded,
                                  size: 18, color: Styles.cSub(context)),
                            ],
                          ),
                          ...List.generate(
                            3,
                            (index) => _DataWithIcon(
                                title: logic.priceList?[index].baseCoin ?? '',
                                icon: logic.priceList?[index].coinImage ?? '',
                                value: logic.priceList?[index].priceChangeH24 ??
                                    0),
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
                    onTap: () => logic.toMarketModule(4),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: FittedBox(
                                        child: Text(
                                          S.of(context).s_liquidation_data,
                                          maxLines: 1,
                                          style: Styles.tsSub_14m(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ' (24H)',
                                    style: Styles.tsSub_14m(context),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_right_rounded,
                                size: 18, color: Styles.cSub(context)),
                          ],
                        ),
                        _DataWithQuantity(
                            title: '24H',
                            value: AppUtil.getLargeFormatString(
                                logic.homeInfoData.value?.liquidation ?? '0'),
                            style: Styles.tsBody_14m(context),
                            isLong: true),
                        _DataWithQuantity(
                            title: S.of(context).s_longs,
                            textColor: Styles.cUp(context),
                            value: AppUtil.getLargeFormatString(
                                logic.homeInfoData.value?.liquidationLong ??
                                    '0'),
                            isLong: true),
                        _DataWithQuantity(
                            title: S.of(context).s_shorts,
                            textColor: Styles.cDown(context),
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
                    onTap: () => logic.toMarketModule(5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    S.of(context).s_funding_rate,
                                    style: Styles.tsSub_14m(context),
                                  ),
                                  Text(
                                    ' (24H)',
                                    style: Styles.tsSub_14m(context),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_right_rounded,
                                size: 18, color: Styles.cSub(context)),
                          ],
                        ),
                        ...List.generate(
                          3,
                          (index) {
                            if (logic.fundRateList.isEmpty) {
                              return const _DataWithoutIcon(
                                  title: '', value: 0);
                            }
                            final item = logic.fundRateList[index];
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
      }),
    );
  }
}

///合约总持仓+合约成交量
class _TotalOiAndFuturesVol extends StatelessWidget {
  const _TotalOiAndFuturesVol({
    required this.logic,
  });

  final HomeLogic logic;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            _FirstLineItem(
              onTap: () => logic.toMarketModule(3),
              title: S.of(context).s_total_oi,
              value: AppUtil.getLargeFormatString(
                  logic.homeInfoData.value?.openInterest ?? '0'),
              rate:
                  double.tryParse(logic.homeInfoData.value?.oiChange ?? '0') ??
                      0,
            ),
            const Gap(9),
            _FirstLineItem(
                onTap: () => AppNav.openWebUrl(
                    title: S.of(context).s_futures_vol_24h,
                    url: Urls.url24HOIVol,
                    showLoading: true),
                title: S.of(context).s_futures_vol_24h,
                rate: double.tryParse(
                        logic.homeInfoData.value?.tickerChange ?? '0') ??
                    0,
                value: AppUtil.getLargeFormatString(
                    logic.homeInfoData.value?.ticker ?? '0')),
            const Gap(9),
            _FirstLineItem(
                onTap: () => AppNav.openWebUrl(
                    title: S.of(context).s_marketcap_ratio,
                    url: Urls.urlBTCMarketCap,
                    showLoading: true),
                title: S.of(context).s_marketcap_ratio,
                rate: (double.tryParse(
                            logic.homeInfoData.value?.marketCpaChange ?? '') ??
                        0) *
                    100,
                value:
                    '${((double.tryParse(logic.homeInfoData.value?.marketCpaValue ?? '') ?? 0) * 100).toStringAsFixed(2)}%'),
          ],
        ),
      );
    });
  }
}

class _LongShortRatio extends StatelessWidget {
  const _LongShortRatio({
    required this.title,
    required this.long,
    required this.rate,
    this.onTap,
  });

  final String title;
  final double long;
  final double rate;
  final VoidCallback? onTap;

  double get actualLong => long / (1 + long);

  double get short => 1 - actualLong;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: _FilledContainer(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Styles.tsSub_14m(context),
                  ),
                ),
                Text((actualLong / short).toStringAsFixed(2),
                    style: Styles.tsBody_14m(context)),
                const Gap(5),
                RateWithArrow(rate: rate * 100)
              ],
            ),
            const Gap(17),
            Stack(
              children: [
                SizedBox(
                  height: 6,
                  child: Row(children: [
                    Expanded(
                        flex: (actualLong * 1000).toInt(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Styles.cUp(context),
                          ),
                        )),
                    Expanded(
                        flex: (short * 1000).toInt(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Styles.cDown(context),
                          ),
                        )),
                  ]),
                ),
                Align(
                  alignment: Alignment(
                      ((actualLong * 1000).toInt() - (short * 1000).toInt()) /
                          ((actualLong * 1000).toInt() +
                              (short * 1000).toInt()),
                      0),
                  child: CustomPaint(
                      size: const Size(0, 6),
                      painter: TrapeziumPainter(
                          width: 4, color: Theme.of(context).cardColor)),
                )
              ],
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
      ),
    );
  }
}

class _DataWithIcon extends StatelessWidget {
  const _DataWithIcon({
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
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
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
    required this.title,
    required this.value,
    this.isLong,
    this.textColor,
    this.style,
  });

  final String title;
  final String value;
  final bool? isLong;
  final Color? textColor;
  final TextStyle? style;

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
              style: (style ?? Styles.tsBody_12m(context))
                  .copyWith(color: textColor),
            ),
          ),
          Text(
            value,
            style: (style ?? Styles.tsBody_12m(context)).copyWith(
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
    this.onTap,
  });

  final String title;
  final String value;
  final double? rate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _FilledContainer(
        onTap: onTap,
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Styles.tsSub_12m(context),
              ),
            ),
            const Gap(2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Styles.tsBody_18m(context),
            ),
            RateWithArrow(rate: (rate ?? 0) * 100, fontSize: 12),
          ],
        ),
      ),
    );
  }
}

class _OutlinedContainer extends StatelessWidget {
  const _OutlinedContainer({
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
        padding: const EdgeInsets.all(10),
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
  const _FilledContainer({this.child, this.onTap});

  final Widget? child;
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
          padding: const EdgeInsets.all(10),
          child: child,
        ),
      ),
    );
  }
}

class _ChartItem extends StatelessWidget {
  const _ChartItem({required this.item});

  final ChartEntity item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          if (item.key == 'more') {
            Get.find<HomeLogic>().tabCtrl.animateTo(1);
            return;
          }
          ['liqMapChart', 'liqHeatMapChart'].contains(item.key)
              ? Get.toNamed(LiqMainPage.routeName,
                  arguments: item.key == 'liqMapChart' ? 0 : 1)
              : AppNav.openWebUrl(
                  url: '${Urls.h5Prefix}${item.path}',
                  title: item.title,
                  showLoading: true,
                );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.key == 'more')
              Image.asset(
                Assets.chartLeftIcMore,
                height: 30,
                width: 30,
              )
            else
              ValueBuilder<int?>(
                initialValue: 0,
                builder: (value, updater) {
                  return ImageUtil.networkImage(
                    key: ValueKey('${item.key}$value'),
                    'https://cdn01.coinank.com/appicons/${item.key}.png',
                    height: 30,
                    width: 30,
                    fadeInDuration: Duration.zero,
                    errorListener: (_) {
                      Future.delayed(
                        const Duration(seconds: 5),
                        () => updater.call((value ?? 0) + 1),
                      );
                    },
                  );
                },
              ),
            const Gap(2),
            Expanded(
              child: Text(
                item.title ?? '',
                style: Styles.tsBody_12m(context),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
