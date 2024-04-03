import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/app_segmented_control.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:ank_app/widget/custom_bottom_sheet/custom_bottom_sheet_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'contract_liq_logic.dart';

class ContractLiqPage extends StatefulWidget {
  const ContractLiqPage({super.key, this.inCoinDetail = false, this.baseCoin});

  final bool inCoinDetail;
  final String? baseCoin;

  @override
  State<ContractLiqPage> createState() => _ContractLiqPageState();
}

class _ContractLiqPageState extends State<ContractLiqPage> {
  late ContractLiqLogic logic = Get.put(ContractLiqLogic(),
      tag: widget.inCoinDetail ? 'coinDetail' : null);

  S get sof => S.of(context);

  @override
  void initState() {
    logic.canSelectCoin = !widget.inCoinDetail;
    logic.selectedCoin.value = widget.baseCoin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!widget.inCoinDetail)
          SizedBox(
            width: double.infinity,
            height: 44,
            child: Row(
              children: [
                Expanded(child: _CoinListView(logic)),
                InkWell(
                  onTap: () => logic.toSearch(),
                  child: Container(
                    padding: const EdgeInsets.only(left: 8),
                    color: Theme.of(context).colorScheme.tertiary,
                    width: 39,
                    height: 24,
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      Assets.commonIcLinesSearch,
                      width: 16,
                      height: 16,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                )
              ],
            ),
          ),
        Expanded(
            child: EasyRefresh(
          onRefresh: widget.inCoinDetail ? null : () async => logic.onRefresh(),
          child: CustomScrollView(
            slivers: [
              const SliverGap(10),
              _orderGridView(),
              _xTraderLiqView(),
              const SliverToBoxAdapter(child: Divider(thickness: 8, height: 8)),
              ..._top3LiqView(),
              ...[
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const Gap(15),
                      Row(
                        children: [
                          const Gap(15),
                          Expanded(
                            child: Text(
                              S.of(context).liqHeatMap,
                              style: Styles.tsBody_14m(context),
                            ),
                          ),
                          Obx(() {
                            return AppSegmentedControl<String>(
                              onValueChanged: (String? value) {
                                logic.filterHeatMapInterval.value =
                                    value ?? '1h';
                                logic.updateHeatMapChart();
                              },
                              groupValue: logic.filterHeatMapInterval.value,
                              children: {
                                '1h': Text(
                                  '1H',
                                  style: Styles.tsBody_12m(context),
                                ),
                                '4h': Text(
                                  '4H',
                                  style: Styles.tsBody_12m(context),
                                ),
                                '12h': Text(
                                  '12H',
                                  style: Styles.tsBody_12m(context),
                                ),
                                '1d': Text(
                                  '1D',
                                  style: Styles.tsBody_12m(context),
                                ),
                              },
                            );
                          }),
                          const Gap(15),
                          Obx(() {
                            return AppSegmentedControl<bool>(
                              onValueChanged: (bool? value) {
                                logic.heatMapIsExchange.value = value ?? false;
                                logic.updateHeatMapChart();
                              },
                              groupValue: logic.heatMapIsExchange.value,
                              children: {
                                false: Text(
                                  sof.symbol,
                                  style: Styles.tsBody_12m(context),
                                ),
                                true: Text(
                                  sof.s_exchange_name,
                                  style: Styles.tsBody_12m(context),
                                ),
                              },
                            );
                          }),
                          const Gap(15),
                        ],
                      ),
                      Container(
                        height: 350,
                        width: double.infinity,
                        margin: const EdgeInsets.all(15),
                        child: CommonWebView(
                          url: Urls.liqHeatMapUrl,
                          enableZoom: true,
                          onLoadStop: (controller) =>
                              logic.updateHeatMapChart(),
                          onWebViewCreated: (controller) {
                            logic.heatMapWebCtrl = controller;
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
              ..._allExchangeLiqView(),
              _lineChartView(),
              ..._orderListView()
            ],
          ),
        ))
      ],
    );
  }

  Widget _xTraderLiqView() {
    return SliverPadding(
      padding: const EdgeInsets.all(15),
      sliver: SliverToBoxAdapter(
        child: Obx(() {
          final text =
              S.of(context).xUsersLiqIn24H(logic.totalLiqTraders.value);
          final parts = text.split('${logic.totalLiqTraders.value}');
          if (parts.length != 2 || logic.totalLiqTraders.value == 24) {
            return Text(
                S.of(context).xUsersLiqIn24H(logic.totalLiqTraders.value),
                style: Styles.tsBody_14(context));
          }
          return RichText(
            text: TextSpan(
              children: [
                TextSpan(text: parts[0], style: Styles.tsBody_14(context)),
                TextSpan(
                    text: '${logic.totalLiqTraders.value}',
                    style: Styles.tsMain_14),
                TextSpan(text: parts[1], style: Styles.tsBody_14(context)),
              ],
            ),
          );
        }),
      ),
    );
  }

  SliverToBoxAdapter _lineChartView() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          const Gap(15),
          Obx(() {
            return Row(
              children: [
                const Gap(15),
                Expanded(
                  child: Text(
                    S.of(context).s_liquidation_data,
                    style: Styles.tsBody_14m(context),
                  ),
                ),
                const Gap(10),
                _filterChip(context, onTap: () async {
                  final result = await logic.openSelectorWithInterceptor();
                  if (result != null &&
                      result.toLowerCase() !=
                          logic.filterLineChartInterval.value.toLowerCase()) {
                    logic.filterLineChartInterval.value = result;
                    logic.loadLineChartData();
                  }
                }, text: logic.filterLineChartInterval.value),
                const Gap(15),
              ],
            );
          }),
          Container(
            height: 350,
            width: double.infinity,
            margin: const EdgeInsets.all(15),
            child: CommonWebView(
              url: Urls.chartUrl,
              enableZoom: true,
              onLoadStop: (controller) =>
                  logic.updateReadyStatus(webReady: true),
              onWebViewCreated: (controller) {
                logic.lineChartWebCtrl = controller;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(
    BuildContext context, {
    String? text,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          height: 30,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerTheme.color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Text(
                text ?? '',
                style: Styles.tsSub_12m(context),
              ),
              const Gap(10),
              const Icon(Icons.keyboard_arrow_down, size: 14)
            ],
          )),
    );
  }

  List<Widget> _orderListView() {
    Widget btn<T>(Rx<T> filter, {String Function(T value)? convertor}) =>
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 30,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerTheme.color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Obx(() {
                  return Text(
                    convertor?.call(filter.value) ??
                        filter.value?.toString() ??
                        sof.s_all,
                    style: Styles.tsSub_12m(context),
                  );
                }),
                const Gap(10),
                const Icon(Icons.keyboard_arrow_down, size: 14)
              ],
            ));
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  S.of(context).liqOrderList,
                  style: Styles.tsBody_16m(context),
                ),
              ),
              InkWell(
                onTap: () async {
                  var result = await _openSelector([
                    'ALL',
                    'Binance',
                    'Huobi',
                    'Okx',
                    'Bitmex',
                    'Bybit',
                    'Gate',
                    'Bitfinex',
                    'Deribit'
                  ], current: logic.filterOrderExchangeName.value);
                  if (result != null) {
                    if (result == 'ALL') result = null;
                    logic.filterOrderExchangeName.value = result;
                    logic.loadLiqOrders();
                  }
                },
                child: btn<String?>(logic.filterOrderExchangeName),
              ),
              const Gap(10),
              InkWell(
                onTap: () async {
                  final result = await _openSelector<(int?, String?)>(
                    [
                      (0, sof.s_all),
                      (1000, '>\$1K'),
                      (10000, '>\$10K'),
                      (100000, '>\$100K'),
                      (1000000, '>\$1M'),
                      (10000000, '>\$10M'),
                    ],
                    current: logic.filterOrderAmount.value,
                    convertor: (value) => value.$2 ?? sof.s_all,
                  );
                  if (result != null) {
                    if (result.$1 == 0) {
                      logic.filterOrderAmount.value = null;
                    } else {
                      logic.filterOrderAmount.value = result;
                    }
                    logic.loadLiqOrders();
                  }
                },
                child: btn<(int?, String?)?>(
                  logic.filterOrderAmount,
                  convertor: (value) => value?.$2 ?? sof.s_all,
                ),
              ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: DefaultTextStyle(
          style: Styles.tsSub_12(context),
          child: SizedBox(
            height: 37,
            child: Row(
              children: [
                const Gap(15),
                Expanded(flex: 14, child: Text(sof.s_exchange_name)),
                Expanded(flex: 14, child: Text(sof.tradingPair)),
                const Gap(3),
                Expanded(flex: 8, child: Text(sof.s_price)),
                Expanded(
                  flex: 12,
                  child: Text(sof.amount, textAlign: TextAlign.end),
                ),
                const Gap(15),
              ],
            ),
          ),
        ),
      ),
      Obx(() {
        return SliverList.builder(
          itemCount: logic.orders.length,
          itemBuilder: (context, index) {
            final item = logic.orders[index];
            return SizedBox(
              height: 60,
              child: Row(
                children: [
                  const Gap(15),
                  Expanded(
                    flex: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            ImageUtil.exchangeImage(item.exchangeName ?? '',
                                size: 24, isCircle: true),
                            const Gap(5),
                            Text(
                                item.exchangeName == 'Okex'
                                    ? 'Okx'
                                    : (item.exchangeName ?? ''),
                                style: Styles.tsBody_14m(context)),
                          ],
                        ),
                        Text(
                          DateFormat('MM-yy HH:mm:ss').format(
                            DateTime.fromMillisecondsSinceEpoch(item.ts ?? 0),
                          ),
                          style: Styles.tsSub_12(context),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 14,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ImageUtil.coinImage(item.baseCoin ?? '', size: 24),
                            const Gap(5),
                            Text(item.baseCoin ?? '',
                                style: Styles.tsBody_14m(context)),
                          ],
                        ),
                        FittedBox(
                          alignment: Alignment.bottomLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(item.contractCode ?? '',
                              style: Styles.tsSub_12(context)),
                        ),
                      ],
                    ),
                  ),
                  const Gap(3),
                  Expanded(
                    flex: 8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          alignment: Alignment.centerLeft,
                          child: Text(_formatDecimal(item.avgPrice ?? 0),
                              style: TextStyle(
                                color: item.posSide == 'short'
                                    ? Styles.cDown(context)
                                    : Styles.cUp(context),
                                fontSize: 14,
                                fontWeight: Styles.fontMedium,
                              )),
                        ),
                        Text(
                            item.posSide == 'short'
                                ? sof.s_shorts
                                : sof.s_longs,
                            style: TextStyle(
                              color: item.posSide == 'short'
                                  ? Styles.cDown(context)
                                  : Styles.cUp(context),
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 12,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 24,
                          alignment: Alignment.centerRight,
                          child: Text(
                            '\$${AppUtil.getLargeFormatString(item.tradeTurnover, precision: 2)}',
                            style: TextStyle(
                              color: item.posSide == 'short'
                                  ? Styles.cDown(context)
                                  : Styles.cUp(context),
                              fontSize: 14,
                              fontWeight: Styles.fontMedium,
                            ),
                          ),
                        ),
                        Text(
                          '≈${AppUtil.getLargeFormatString(item.amount, precision: 2)} ${item.baseCoin}',
                          style: TextStyle(
                            color: item.posSide == 'short'
                                ? Styles.cDown(context)
                                : Styles.cUp(context),
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                  const Gap(15),
                ],
              ),
            );
          },
        );
      }),
      const SliverGap(100),
    ];
  }

  Future<T?> _openSelector<T>(List<T> items,
      {T? current, String Function(T value)? convertor}) async {
    final result = await showCupertinoModalPopup(
      context: context,
      builder: (context) => CustomSelector(
        title: '',
        dataList: items,
        current: current,
        convertor: convertor,
      ),
      barrierDismissible: true,
      barrierColor: Colors.black26,
    );

    return result as T?;
  }

  List<Widget> _allExchangeLiqView() {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  S.of(context).allExchangesLiqData,
                  style: Styles.tsBody_16m(context),
                ),
              ),
              InkWell(
                onTap: () async {
                  final result = await _openSelector<String>(
                      ['1h', '4h', '12h', '1d'],
                      current: logic.filterAllExchangeInterval.value);
                  if (result != null) {
                    logic.filterAllExchangeInterval.value = result;
                    logic.loadAllExchanges();
                  }
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    height: 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerTheme.color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Obx(() {
                          return Text(
                            logic.filterAllExchangeInterval.value,
                            style: Styles.tsSub_12m(context),
                          );
                        }),
                        const Gap(10),
                        const Icon(Icons.keyboard_arrow_down, size: 14)
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        sliver: SliverToBoxAdapter(
          child: SizedBox(
            height: 37,
            child: DefaultTextStyle(
              style: Styles.tsSub_12(context),
              child: Row(
                children: [
                  Expanded(
                      flex: 10,
                      child: Text(
                        sof.s_exchange_name,
                      )),
                  Expanded(flex: 10, child: Text(sof.s_rekt)),
                  Expanded(flex: 10, child: Text(sof.percentage)),
                  Expanded(
                      flex: 10,
                      child: Text(
                        '${sof.s_longs}/${sof.s_shorts}',
                        textAlign: TextAlign.end,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
      Obx(() {
        return SliverList.builder(
          itemCount: logic.allExchanges.length,
          itemBuilder: (context, index) {
            final item = logic.allExchanges[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                        flex: 10,
                        child: Row(
                          children: [
                            ImageUtil.exchangeImage(item.exchangeName ?? '',
                                size: 24, isCircle: true),
                            const Gap(3),
                            Text(
                              item.exchangeName == 'Okex'
                                  ? 'Okx'
                                  : (item.exchangeName ?? ''),
                              style: Styles.tsBody_14m(context),
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 10,
                        child: Text(
                          AppUtil.getLargeFormatString(item.totalTurnover,
                              precision: 2),
                          style: Styles.tsBody_14m(context),
                        )),
                    Expanded(
                        flex: 8,
                        child: Text(
                          '${((item.percentage ?? 0) * 100).toStringAsFixed(2)}%',
                          style: Styles.tsBody_14m(context),
                        )),
                    Expanded(
                      flex: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(colors: [
                            Styles.cUp(context),
                            Styles.cUp(context),
                            Styles.cDown(context),
                            Styles.cDown(context),
                            Styles.cTextFieldFill(context),
                            Styles.cTextFieldFill(context),
                          ], stops: [
                            0,
                            item.longRatio ?? 0,
                            item.longRatio ?? 0,
                            (item.longRatio ?? 0) + (item.shortRatio ?? 0),
                            (item.longRatio ?? 0) + (item.shortRatio ?? 0),
                            1
                          ]),
                        ),
                        child: DefaultTextStyle(
                          style: const TextStyle(
                              fontWeight: Styles.fontMedium,
                              fontSize: 12,
                              color: Colors.white),
                          child: SizedBox(
                            height: 20,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${((item.longRatio ?? 0) * 100).toStringAsFixed(2)}%',
                                  ),
                                ),
                                Text(
                                  '${((item.shortRatio ?? 0) * 100).toStringAsFixed(2)}%',
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      })
    ];
  }

  String _formatDecimal(double value) {
    final s = '$value';
    final parts = s.split('.');
    if (parts[0] != '0') {
      return value.toStringAsFixed(2);
    }
    if (parts.length <= 1) {
      return '$value';
    }
    if (!parts[1].startsWith('000')) {
      return value.toStringAsFixed(4);
    } else {
      final sb = StringBuffer('0.');
      int count = 0;
      for (int i = 0; i < parts[1].length; i++) {
        final c = parts[1][i];
        sb.write(c);
        if (c != '0') count++;
        if (count == 2) break;
      }
      return sb.toString();
    }
  }

  List<Widget> _top3LiqView() {
    return [
      SliverPadding(
        padding: const EdgeInsets.all(15),
        sliver: SliverToBoxAdapter(
            child: Text(S.of(context).singleOrderLiqTop3,
                style: Styles.tsBody_16m(context))),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        sliver: SliverToBoxAdapter(
          child: DefaultTextStyle(
            style: Styles.tsSub_12(context),
            child: Row(
              children: [
                const Expanded(child: Text('Top')),
                Expanded(child: Text(sof.s_exchange_name)),
                Expanded(child: Text(sof.tradingPair)),
                Expanded(child: Text(sof.side)),
                Expanded(child: Text(sof.amount, textAlign: TextAlign.end)),
              ],
            ),
          ),
        ),
      ),
      Obx(() {
        return SliverList.builder(
          itemCount: logic.exchangeIntervalTops.length,
          itemBuilder: (context, index) {
            final item = logic.exchangeIntervalTops[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    '${index + 1}',
                    style: Styles.tsBody_14m(context),
                  )),
                  Expanded(
                      child: Text(
                    item.exchangeName == 'Okex'
                        ? 'Okx'
                        : (item.exchangeName ?? ''),
                    style: Styles.tsBody_14m(context),
                  )),
                  Expanded(
                      child: Text(
                    item.baseCoin ?? '',
                    style: Styles.tsBody_14m(context),
                  )),
                  Expanded(
                      child: Text(
                    switch (item.posSide) {
                      'long' => sof.s_longs,
                      'short' => sof.s_shorts,
                      _ => ''
                    },
                    style: TextStyle(
                      color: item.posSide == 'long'
                          ? Styles.cUp(context)
                          : Styles.cDown(context),
                      fontSize: 14,
                      fontWeight: Styles.fontMedium,
                    ),
                  )),
                  Expanded(
                    child: Text(
                      AppUtil.getLargeFormatString(item.tradeTurnover,
                          precision: 2),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: item.posSide == 'long'
                            ? Styles.cUp(context)
                            : Styles.cDown(context),
                        fontSize: 14,
                        fontWeight: Styles.fontMedium,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      })
    ];
  }

  Widget _orderGridView() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      sliver: Obx(() {
        return SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 9,
              mainAxisSpacing: 9,
              mainAxisExtent: 94),
          itemBuilder: (context, index) {
            final item = logic.exchangeIntervals[index];
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Styles.cLine(context)),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Text(
                        item.interval ?? '',
                        style: Styles.tsBody_14m(context),
                      ),
                      Expanded(
                          child: Text(
                        '\$${AppUtil.getLargeFormatString(item.totalTurnover, precision: 2)}',
                        style: Styles.tsBody_14m(context),
                        textAlign: TextAlign.end,
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        sof.s_longs,
                        style: TextStyle(
                            color: Styles.cUp(context),
                            fontSize: 12,
                            fontWeight: Styles.fontMedium),
                      ),
                      Expanded(
                          child: Text(
                        '\$${AppUtil.getLargeFormatString(item.longTurnover, precision: 2)}',
                        style: TextStyle(
                            color: Styles.cUp(context),
                            fontSize: 12,
                            fontWeight: Styles.fontMedium),
                        textAlign: TextAlign.end,
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        sof.s_shorts,
                        style: TextStyle(
                            color: Styles.cDown(context),
                            fontSize: 12,
                            fontWeight: Styles.fontMedium),
                      ),
                      Expanded(
                          child: Text(
                        '\$${AppUtil.getLargeFormatString(item.shortTurnover, precision: 2)}',
                        style: TextStyle(
                            color: Styles.cDown(context),
                            fontSize: 12,
                            fontWeight: Styles.fontMedium),
                        textAlign: TextAlign.end,
                      ))
                    ],
                  )
                ],
              ),
            );
          },
          itemCount: logic.exchangeIntervals.length,
        );
      }),
    );
  }
}

class _CoinListView extends StatelessWidget {
  const _CoinListView(this.logic);

  final ContractLiqLogic logic;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ScrollablePositionedList.builder(
          itemScrollController: logic.itemScrollController,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          itemCount: logic.coinList.length,
          itemBuilder: (context, index) {
            final item = logic.coinList[index];
            return GestureDetector(
              onTap: () {
                if (item != 'ALL') {
                  logic.selectedCoin.value = item;
                } else {
                  logic.selectedCoin.value = null;
                }
                logic.coinList.refresh();
                logic.onRefresh();
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: item == logic.selectedCoin.value ||
                              (item == 'ALL' &&
                                  logic.selectedCoin.value == null)
                          ? Styles.cMain.withOpacity(0.1)
                          : null),
                  child: Text(item,
                      style: item == logic.selectedCoin.value ||
                              (item == 'ALL' &&
                                  logic.selectedCoin.value == null)
                          ? Styles.tsMain_14
                          : Styles.tsSub_14(context))),
            );
          },
          scrollDirection: Axis.horizontal);
    });
  }
}
