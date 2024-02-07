import 'dart:convert';
import 'dart:io';

import 'package:ank_app/generated/l10n.dart';
import 'package:ank_app/res/styles.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

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
                _timeItem(S.of(context).timeDivider, null),
                _timeItem('15m', '15m'),
                _timeItem('1h', '1h'),
                _timeItem('1d', '1d'),
                _timeItem('7d', '1w'),
                _timeItem('30d', '1M'),
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
            url: 'assets/files/kline.html',
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
      'exchangeType': widget.isSpot ? 'SPOT' : 'SWAP'
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
    var localeString = jsonEncode({'locale': 'zh'});
    var jsSource = '''
        setChartData($dataParamsString, "$platformString", "kline", $localeString);    
                ''';
    print(jsSource);
    webCtrl?.evaluateJavascript(source: jsSource);
  }
}
