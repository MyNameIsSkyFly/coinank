import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/entity/oi_chart_menu_param_entity.dart';
import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_contract/coin_detail_contract_logic.dart';
import 'package:ank_app/modules/coin_detail/widgets/coin_detail_chart_kline_view.dart';
import 'package:ank_app/modules/coin_detail/widgets/coin_detail_fund_flow_view.dart';
import 'package:ank_app/modules/coin_detail/widgets/coin_detail_selector_view.dart';
import 'package:ank_app/modules/home/exchange_oi/exchange_oi_view.dart';
import 'package:ank_app/modules/market/contract/contract_liq/contract_liq_view.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/animated_color_text.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:ank_app/widget/rate_with_sign.dart';
import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:decimal/decimal.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

part './_chart_weighted_funding_view.dart';
part './_data_grid_view.dart';
part './_heat_map_view.dart';
part './_vol_24h_view.dart';

class CoinDetailContractView extends StatefulWidget {
  const CoinDetailContractView({super.key});

  @override
  State<CoinDetailContractView> createState() => _CoinDetailContractViewState();
}

class _CoinDetailContractViewState extends State<CoinDetailContractView>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(CoinDetailContractLogic());

  InAppWebViewController? webCtrl;

  @override
  void initState() {
    logic.tabCtrl =
        TabController(length: 7, vsync: this, animationDuration: Duration.zero);

    super.initState();
  }

  final dataExpanded = false.obs;

  @override
  Widget build(BuildContext context) {
    return ExtendedNestedScrollView(
      onlyOneScrollInBody: true,
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
                            style: const TextStyle(
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
                              'SWAP');
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
          SliverToBoxAdapter(
            child: Obx(() {
              return Column(
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
                      '${logic.coin24hInfo.value?.priceChange24h?.toStringAsFixed(2) ?? 0}%'
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
                  if (dataExpanded.value) ...[
                    _rowGroup([
                      (
                        S.of(context).longRatio4h,
                        '${((logic.info.value?.longRatio4h ?? 0) * 100).toStringAsFixed(2)}%'
                      ),
                      (
                        S.of(context).shortRatio4h,
                        '${((logic.info.value?.shortRatio4h ?? 0) * 100).toStringAsFixed(2)}%'
                      ),
                      (
                        S.of(context).longShortRatio4h,
                        '${logic.info.value?.longShortRatio4h}'
                      ),
                    ], [
                      (
                        S.of(context).swapOi,
                        AppUtil.getLargeFormatString(
                            '${logic.info.value?.swapOiUSD24h}')
                      ),
                      (
                        '${S.of(context).swapTurnover}(24H)',
                        AppUtil.getLargeFormatString(
                            '${logic.info.value?.swapTurnover24h}')
                      ),
                      (
                        '${S.of(context).swapTradeTimes}(24H)',
                        '${logic.info.value?.swapTradeTimes24h}'
                      ),
                    ]),
                    _rowGroup([
                      (
                        S.of(context).futureOi,
                        AppUtil.getLargeFormatString(
                            '${logic.info.value?.futureOiUSD24h}')
                      ),
                      (
                        '${S.of(context).futureTurnover}(24H)',
                        AppUtil.getLargeFormatString(
                            '${logic.info.value?.futureTurnover24h}')
                      ),
                      (
                        '${S.of(context).futureTradeTimes}(24H)',
                        '${logic.info.value?.futureTradeTimes24h}'
                      ),
                    ], [
                      (
                        '${S.of(context).s_rekt}(24H)',
                        AppUtil.getLargeFormatString(
                            '${logic.info.value?.liq24h}')
                      ),
                      (
                        S.of(context).shortLiq,
                        AppUtil.getLargeFormatString(
                            '${logic.info.value?.shortLiq24h}')
                      ),
                      (
                        S.of(context).longLiq,
                        AppUtil.getLargeFormatString(
                            '${logic.info.value?.longLiq24h}')
                      ),
                    ]),
                  ],
                  Transform.scale(
                    scaleY: 0.6,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: dataExpanded.toggle,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            dataExpanded.value
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Styles.cSub(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 8,
                    thickness: 8,
                    color: Theme.of(context).cardColor,
                  ),
                ],
              );
            }),
          ),
          SliverToBoxAdapter(
              child: ChartKlineView(
            baseCoin: logic.detailLogic.coin.baseCoin ?? '',
            symbol: logic.detailLogic.coin.symbol ?? '',
            exchangeName: logic.detailLogic.coin.exchangeName ?? '',
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
            controller: logic.tabCtrl,
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
              Tab(text: S.of(context).tradingPosition),
              Tab(text: S.of(context).s_24h_turnover),
              Tab(text: S.of(context).s_liquidation_data),
              Tab(text: S.of(context).weightedRate),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: logic.tabCtrl,
              children: [
                _DataGridView(logic: logic),
                _HeatMapView(logic: logic),
                CoinDetailFundFlowView(
                  isSpot: false,
                  baseCoin: logic.baseCoin,
                  exchangeName: logic.detailLogic.coin.exchangeName,
                ),
                // _ExchangeOiView(logic: logic),
                const ExchangeOiPage(inCoinDetail: true),
                _Vol24hView(logic: logic),
                AliveWidget(
                    child: ContractLiqPage(
                        inCoinDetail: true, baseCoin: logic.baseCoin)),
                _ChartWeightedFundingView(logic: logic),
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
