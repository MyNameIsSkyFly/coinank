import 'dart:convert';
import 'dart:io';

import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

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
  InAppWebViewController? webCtrl;

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
    )));
  }

  final timeItems = ['1m', '3m', '5m', '30m', '2h', '6h', '12h'];

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
                _timeItem('1h', '1h'),
                _timeItem('4h', '4h'),
                _timeItem('1d', '1d'),
                _timeItem('7d', '1w'),
                _timeItem('30d', '1M'),
                Expanded(
                    child: Center(
                        child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    final result = await openSelector(timeItems);
                    if (result == null) return;
                    interval.value = result;
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
          child: CommonWebView(
            onWebViewCreated: (controller) => webCtrl = controller,
            onLoadStop: (controller) async => _evaluate(),
            url: Urls.klineUrl,
            enableZoom: true,
          ),
        ),
      ],
    );
  }

  final interval = '15m'.obs;

  void _evaluate() {
    final dataParams = {
      'baseCoin': widget.baseCoin,
      'exchange': widget.exchangeName,
      'symbol': widget.symbol,
      'interval': interval.value,
      'exchangeType': widget.isSpot ? 'SPOT' : 'SWAP',
      // 'baseCoin': widget.logic.baseCoin,
      //币
      // 'productType': 'CONTRACT',
      // "SPOT"现货, "CONTRACT":合约
      // 'type': isOi.value ? 'oi' : 'vol'
      // vol: 成交量, oi: 持仓
    };
    // setChartData({exchange: "Okex",//交易所
    //   symbol: "BTC-USDT",//交易对
    //   interval: "30m",//时间级别
    //   exchangeType: "SPOT"}, //交易对类型 SPOT 现货, SWAP,永续
    //     "android",
    //     "kline",
    //     {
    //       theme: "light",//主题
    //       locale:"zh"//语言
    //     })
    var platformString = Platform.isAndroid ? 'android' : 'ios';
    var dataParamsString = jsonEncode(dataParams);
    var localeString = jsonEncode({'locale': AppUtil.shortLanguageName});
    var jsSource = '''
        setChartData($dataParamsString, "$platformString", "kline", $localeString);    
                ''';
    webCtrl?.evaluateJavascript(source: jsSource);
  }
}
