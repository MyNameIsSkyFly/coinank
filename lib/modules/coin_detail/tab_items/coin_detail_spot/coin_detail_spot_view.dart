import 'dart:convert';
import 'dart:io';

import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/entity/oi_chart_menu_param_entity.dart';
import 'package:ank_app/modules/coin_detail/widgets/coin_detail_chart_kline_view.dart';
import 'package:ank_app/modules/coin_detail/widgets/coin_detail_fund_flow_view.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/animated_color_text.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:ank_app/widget/rate_with_sign.dart';
import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../widgets/coin_detail_selector_view.dart';
import 'coin_detail_spot_logic.dart';

part '_data_grid_view.dart';
part '_heat_map_view.dart';
part '_vol_24h_view.dart';

class CoinDetailSpotView extends StatefulWidget {
  const CoinDetailSpotView({super.key});

  @override
  State<CoinDetailSpotView> createState() => _CoinDetailSpotViewState();
}

class _CoinDetailSpotViewState extends State<CoinDetailSpotView>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(CoinDetailSpotLogic());
  late TabController tabCtrl;

  @override
  void initState() {
    tabCtrl =
        TabController(length: 4, vsync: this, animationDuration: Duration.zero);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          Obx(() {
            return SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 69,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedColorText(
                            text:
                                '\$${Decimal.parse('${logic.coin24hInfo.value?.lastPrice ?? 0}')}',
                            value: logic.coin24hInfo.value?.lastPrice ?? 0,
                            style: TextStyle(
                                fontWeight: Styles.fontMedium, fontSize: 18),
                          ),
                          RateWithSign(
                              rate: logic.coin24hInfo.value?.priceChange24h),
                        ],
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          AppUtil.toKLine(
                              logic.detailLogic.coin.exchangeName ?? '',
                              logic.detailLogic.coin.symbol ?? '',
                              logic.baseCoin,
                              'SPOT');
                        },
                        child: const ImageIcon(
                            AssetImage(Assets.commonIcCandleLine),
                            size: 20)),
                    const Gap(20),
                    Obx(() {
                      return GestureDetector(
                        onTap: logic.toggleMarked,
                        child: ImageIcon(
                            AssetImage(logic.marked.value
                                ? Assets.commonIconStarFill
                                : Assets.commonIconStar),
                            color: logic.marked.value
                                ? Styles.cYellow
                                : Styles.cBody(context),
                            size: 20),
                      );
                    })
                  ],
                ),
              ),
            );
          }),
          Obx(() {
            return SliverToBoxAdapter(
              child: Column(
                children: [
                  _rowGroup([
                    (
                      S.of(context).high24h,
                      '\$${Decimal.parse('${logic.coin24hInfo.value?.high24h ?? 0}')}'
                    ),
                    (
                      S.of(context).low24h,
                      '\$${Decimal.parse('${logic.coin24hInfo.value?.low24h ?? 0}')}'
                    ),
                    (
                      S.of(context).priceChange24h,
                      '${logic.coin24hInfo.value?.priceChange24h?.toStringAsFixed(2)}%'
                    ),
                  ], [
                    (
                      S.of(context).volCcy24h,
                      '${(logic.coin24hInfo.value?.volCcy24h ?? 0).let((it) => it < 10000000000000 ? it : AppUtil.getLargeFormatString('$it'))} ${logic.baseCoin}'
                    ),
                    (
                      S.of(context).s_24h_turnover,
                      '\$${AppUtil.getLargeFormatString('${logic.coin24hInfo.value?.turnover24h}', precision: 2)}'
                    ),
                    (
                      S.of(context).changeRate24h,
                      '${logic.coin24hInfo.value?.changeRate ?? 0}%'
                    ),
                  ]),
                ],
              ),
            );
          }),
          SliverToBoxAdapter(
            child: Divider(
              height: 8,
              thickness: 8,
              color: Theme.of(context).cardColor,
            ),
          ),
          SliverToBoxAdapter(
              child: ChartKlineView(
            baseCoin: logic.detailLogic.coin.baseCoin ?? '',
            symbol: logic.detailLogic.coin.symbol ?? '',
            exchangeName: logic.detailLogic.coin.exchangeName ?? '',
            isSpot: true,
          )),
          SliverToBoxAdapter(
            child: Divider(
              height: 8,
              thickness: 8,
              color: Theme.of(context).cardColor,
            ),
          )
        ];
      },
      body: Column(
        children: [
          TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            controller: tabCtrl,
            indicator: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Styles.cMain, width: 2))),
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: Styles.tsBody_14m(context),
            unselectedLabelStyle: Styles.tsSub_14m(context),
            tabs: [
              Tab(text: S.of(context).s_tickers),
              Tab(text: S.of(context).heat_map),
              Tab(text: S.of(context).funds),
              Tab(text: S.of(context).s_24h_turnover),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabCtrl,
              children: [
                _DataGridView(logic: logic),
                _HeatMapView(logic: logic),
                CoinDetailFundFlowView(
                    isSpot: true,
                    baseCoin: logic.baseCoin,
                    exchangeName: logic.detailLogic.coin.exchangeName),
                _Vol24hView(logic: logic),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowGroup(List<(String, String)> items1,
      List<(String title, String value)> items2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: items1.map((e) => _row(e.$1, e.$2)).toList(),
            ),
          ),
          const SizedBox(
              height: 51,
              child: VerticalDivider(
                width: 20,
                thickness: 1,
              )),
          Expanded(
            child: Column(
              children: items2.map((e) => _row(e.$1, e.$2)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(title, style: Styles.tsSub_12(context))),
          ),
        ),
        const Gap(4),
        Text(value, style: Styles.tsBody_12(context)),
      ],
    );
  }
}
