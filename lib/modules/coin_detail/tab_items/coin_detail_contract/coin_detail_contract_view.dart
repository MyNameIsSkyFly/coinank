import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_contract/coin_detail_contract_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/animated_color_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

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
              child: SizedBox(
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
                          ),
                          Text('\$${coinInfo.priceChangeH24}'),
                        ],
                      ),
                    ),
                    FilledButton(
                        style: FilledButton.styleFrom(
                            maximumSize: Size(100, 40),
                            minimumSize: Size(100, 40),
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
                        child: Text(S.of(context).s_order_flow))
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
                      '24H高',
                      '\$${logic.coin24hInfo.value?.high24h?.toInt() ?? 0}'
                    ),
                    (
                      '24H低',
                      '\$${logic.coin24hInfo.value?.low24h?.toInt() ?? 0}'
                    ),
                    (
                      '24H波幅',
                      '${logic.coin24hInfo.value?.priceChange24h?.toStringAsFixed(2)}%'
                    ),
                  ], [
                    ('24H量', '${logic.coin24hInfo.value?.vol24h}'),
                    ('24H额', '${logic.coin24hInfo.value?.turnover24h}'),
                    ('24H换手', '${logic.coin24hInfo.value?.vol24h}'),
                  ]),
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
              ),
            );
          }),
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
                Container(),
                Container(),
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
