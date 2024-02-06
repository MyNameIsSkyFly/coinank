import 'dart:convert';
import 'dart:io';

import 'package:ank_app/res/styles.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:ank_app/widget/keep_alive_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../coin_detail_spot_logic.dart';

class HeatMapView extends StatefulWidget {
  const HeatMapView({
    super.key,
    required this.logic,
  });

  final CoinDetailSpotLogic logic;

  @override
  State<HeatMapView> createState() => _HeatMapViewState();
}

class _HeatMapViewState extends State<HeatMapView> {
  InAppWebViewController? webCtrl;

  @override
  Widget build(BuildContext context) {
    return AliveWidget(
      child: OverflowBox(
        minHeight: 600,
        maxHeight: 600,
        minWidth: MediaQuery.of(context).size.width - 30,
        maxWidth: MediaQuery.of(context).size.width - 30,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //todo intl
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Text('热力图', style: Styles.tsBody_14m(context)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerTheme.color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '24H成交额',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: Styles.fontMedium,
                            color: Styles.cBody(context)),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 400,
              width: double.infinity,
              child: CommonWebView(
                onWebViewCreated: (controller) => webCtrl = controller,
                onLoadStop: (controller) async => _evaluate(),
                url: 'assets/files/heatmap.html',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _evaluate() {
    final dataParams = {
      'baseCoin': widget.logic.baseCoin,
      //币
      'productType': 'SPOT',
      // "SPOT"现货, "CONTRACT":合约
      'type': 'vol'
      // vol: 成交量, oi: 持仓
    };
    var platformString = Platform.isAndroid ? 'android' : 'ios';
    var dataParamsString = jsonEncode(dataParams);
    var localeString = jsonEncode({'locale': 'zh'});
    var jsSource = '''
        setChartData($dataParamsString, "$platformString", "tickerHeatMap", $localeString);    
                ''';
    webCtrl?.evaluateJavascript(source: jsSource);
  }
}
