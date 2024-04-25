import 'package:ank_app/res/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k_chart/flutter_k_chart.dart' hide S;

import 'coin_detail_selector_view.dart';

class ChartKlineView extends StatefulWidget {
  const ChartKlineView({
    super.key,
    required this.baseCoin,
    required this.symbol,
    required this.exchangeName,
    this.isSpot = false,
  });

  final String baseCoin;
  final String symbol;
  final String exchangeName;
  final bool isSpot;

  @override
  State<ChartKlineView> createState() => _ChartKlineViewState();
}

class _ChartKlineViewState extends State<ChartKlineView> {
  // InAppWebViewController? webCtrl;
  final _klineDataList = RxList<KLineEntity>();

  @override
  void initState() {
    initKlineDataList();
    super.initState();
  }

  Widget _timeItem(String text, String? value) {
    return Expanded(
      child: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: value == null
              ? null
              : () {
                  interval.value = value;
                  _evaluate();
                },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              text,
              style: interval.value == value
                  ? Styles.tsMain_12
                  : Styles.tsSub_12(context),
            ),
          ),
        ),
      ),
    );
  }

  final timeItems = ['1m', '3m', '5m', '30m', '2H', '6H', '12H'];

  Future<String?> openSelector(List<String> items) async {
    final result = await showCupertinoModalPopup(
      context: context,
      builder: (context) =>
          SelectorSheetWithInterceptor(title: '', dataList: items),
      barrierDismissible: true,
      barrierColor: Colors.black26,
    );

    return result as String?;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTextStyle(
          style: Styles.tsSub_12(context),
          child: Obx(() {
            return Row(
              children: [
                _timeItem('15m', '15m'),
                _timeItem('1H', '1h'),
                _timeItem('4H', '4h'),
                _timeItem('1D', '1d'),
                _timeItem('1W', '1w'),
                _timeItem('1M', '1M'),
                Expanded(
                    child: Center(
                        child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    final result = await openSelector(timeItems);
                    if (result == null) return;
                    interval.value = result.toLowerCase();
                    _evaluate();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: FittedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() {
                            var contains = timeItems.contains(interval.value);
                            return Text(
                              contains ? interval.value : S.of(context).more,
                              style: contains
                                  ? Styles.tsMain_12
                                  : Styles.tsSub_12(context),
                            );
                          }),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Styles.cSub(context),
                            size: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ))),
              ],
            );
          }),
        ),
        SizedBox(
          height: 250,
          width: double.infinity,
          child: Obx(() {
            return KChartWidget(
              _klineDataList.value,
              ChartStyle()..topPadding = 0,
              ChartColors()
                // ..selectFillColor = Styles.cSub(context).withOpacity(0.4)
                ..volColor = Styles.cMain
                ..vCrossColor = Styles.cSub(context).withOpacity(0.2)
                ..hCrossColor = Styles.cSub(context).withOpacity(0.2)
                ..lineFillColor = Styles.cUp(context)
                ..kLineColor = Styles.cUp(context)
                ..lineFillInsideColor = Styles.cScaffoldBackground(context)
                ..gridColor = Styles.cScaffoldBackground(context)
                ..upColor = Styles.cSub(context).withOpacity(0.4)
                ..dnColor = Styles.cSub(context).withOpacity(0.4)
                ..nowPriceTextColor = Colors.white
                ..nowPriceUpColor = Styles.cMain
                ..nowPriceDnColor = Styles.cMain
                ..defaultTextColor = Styles.cSub(context)
                ..bgColor = [
                  Styles.cScaffoldBackground(context),
                  Styles.cScaffoldBackground(context)
                ],
              xFrontPadding: 0,
              secondaryState: SecondaryState.NONE,
              isTrendLine: false,
              isLine: true,
              isTapShowInfoDialog: true,
              showNowPrice: false,
            );
          }),
        ),
      ],
    );
  }

  final interval = '15m'.obs;

  Future<void> initKlineDataList() async {
    final data = await Apis().getKlineList(
      size: 500,
      exchange: widget.exchangeName,
      symbol: widget.symbol,
      exchangeType: widget.isSpot ? 'SPOT' : 'SWAP',
      interval: interval.value,
      side: 'to',
    );
    _klineDataList.assignAll((data?.data ?? [])
        .map((e) => KLineEntity.fromCustom(
              time: e[0]?.toInt(),
              open: e[2] ?? 0,
              close: e[3] ?? 0,
              high: e[4] ?? 0,
              low: e[5] ?? 0,
              vol: e[6] ?? 0,
            ))
        .toList());
  }

  void _evaluate() {
    initKlineDataList();
  }
}
