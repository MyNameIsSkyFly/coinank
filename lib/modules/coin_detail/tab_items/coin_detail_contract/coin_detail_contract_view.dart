import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_contract/coin_detail_contract_logic.dart';
import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_contract/widget/_chart_kline_view.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/animated_color_text.dart';
import 'package:ank_app/widget/rate_with_sign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'widget/_chart_liq_view.dart';
import 'widget/_chart_weighted_funding_view.dart';
import 'widget/_data_grid_view.dart';
import 'widget/_exchange_oi_view.dart';
import 'widget/_heat_map_view.dart';
import 'widget/_vol_24h_view.dart';

class CoinDetailContractView extends StatefulWidget {
  const CoinDetailContractView({super.key});

  @override
  State<CoinDetailContractView> createState() => _CoinDetailContractViewState();
}

class _CoinDetailContractViewState extends State<CoinDetailContractView>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(CoinDetailContractLogic());

  InAppWebViewController? webCtrl;
  late TabController tabCtrl;

  @override
  void initState() {
    tabCtrl =
        TabController(length: 6, vsync: this, animationDuration: Duration.zero);

    super.initState();
  }

  final dataExpanded = false.obs;
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          Obx(() {
            var coinInfo = logic.detailLogic.contractLogic.state.data
                .where((p0) => p0.baseCoin == logic.baseCoin)
                .first;
            return SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 100,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
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
                      ),
                    ),
                    FilledButton(
                        style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            minimumSize: Size.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            )),
                        onPressed: () {
                          AppUtil.toKLine(
                              coinInfo.exchangeName ?? '',
                              coinInfo.symbol ?? '',
                              logic.baseCoin ?? '',
                              'SWAP');
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              S.of(context).s_order_flow,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                            Icon(Icons.keyboard_arrow_right_rounded, size: 17)
                          ],
                        ))
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
                      '24H高',
                      '\$${logic.coin24hInfo.value?.high24h?.toInt() ?? 0}'
                    ),
                    (
                      '24H低',
                      '\$${logic.coin24hInfo.value?.low24h?.toInt() ?? 0}'
                    ),
                    (
                      '24H波幅',
                      '${logic.coin24hInfo.value?.priceChange24h?.toStringAsFixed(2) ?? 0}%'
                    ),
                  ], [
                    (
                      '24H量',
                      '${logic.coin24hInfo.value?.volCcy24h ?? 0} ${logic.baseCoin}'
                    ),
                    (
                      '24H额',
                      '\$${AppUtil.getLargeFormatString('${logic.coin24hInfo.value?.turnover24h}', precision: 2)}'
                    ),
                    ('24H换手', '${logic.coin24hInfo.value?.changeRate ?? 0}%'),
                  ]),
                  if (dataExpanded.value) ...[
                    _rowGroup([
                      (
                        '4H多单',
                        '${((logic.info.value?.longRatio4h ?? 0) * 100).toStringAsFixed(2)}%'
                      ),
                      (
                        '4H空单',
                        '${((logic.info.value?.shortRatio4h ?? 0) * 100).toStringAsFixed(2)}%'
                      ),
                      ('4H多空比', '${logic.info.value?.longShortRatio4h}'),
                    ], [
                    (
                      '永续持仓',
                      AppUtil.getLargeFormatString(
                          '${logic.info.value?.swapOiUSD24h}')
                    ),
                    (
                      '永续成交额(24H)',
                      AppUtil.getLargeFormatString(
                          '${logic.info.value?.swapTurnover24h}')
                    ),
                    ('永续成交笔数(24H)', '${logic.info.value?.swapTradeTimes24h}'),
                  ]),
                  _rowGroup([
                    (
                      '交割持仓',
                      AppUtil.getLargeFormatString(
                          '${logic.info.value?.futureOiUSD24h}')
                    ),
                    (
                      '交割成交额(24H)',
                      AppUtil.getLargeFormatString(
                          '${logic.info.value?.futureTurnover24h}')
                    ),
                    ('交割成交笔数(24H)', '${logic.info.value?.futureTradeTimes24h}'),
                  ], [
                    (
                      '爆仓(24H)',
                      AppUtil.getLargeFormatString(
                          '${logic.info.value?.liq24h}')
                    ),
                    (
                      '空单爆仓',
                      AppUtil.getLargeFormatString(
                          '${logic.info.value?.shortLiq24h}')
                    ),
                    (
                      '多单爆仓',
                      AppUtil.getLargeFormatString(
                          '${logic.info.value?.longLiq24h}')
                    ),
                    ]),
                  ],
                  Transform.scale(
                    scaleY: 0.6,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => dataExpanded.toggle(),
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
        ];
      },
      body: Column(
        children: [
          TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            controller: tabCtrl,
            tabs: [
              Tab(text: S.of(context).s_tickers),
              Tab(text: S.of(context).heatMap),
              Tab(text: S.of(context).tradingPosition),
              Tab(text: S.of(context).s_24h_turnover),
              Tab(text: S.of(context).s_liquidation_data),
              Tab(text: S.of(context).weightedRate),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabCtrl,
              children: [
                DataGridView(logic: logic),
                HeatMapView(logic: logic),
                ExchangeOiView(logic: logic),
                Vol24hView(logic: logic),
                ChartLiqView(logic: logic),
                ChartWeightedFundingView(logic: logic),
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
