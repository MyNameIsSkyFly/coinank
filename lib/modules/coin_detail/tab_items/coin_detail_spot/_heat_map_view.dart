part of 'coin_detail_spot_view.dart';

class _HeatMapView extends StatefulWidget {
  const _HeatMapView({
    super.key,
    required this.logic,
  });

  final CoinDetailSpotLogic logic;

  @override
  State<_HeatMapView> createState() => _HeatMapViewState();
}

class _HeatMapViewState extends State<_HeatMapView> {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Text(S.of(context).heat_map,
                      style: Styles.tsBody_14m(context)),
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
                        S.of(context).s_24h_turnover,
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
                enableZoom: true,
                onLoadStop: (controller) async => _evaluate(),
                url: Urls.heatMapUrl,
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
