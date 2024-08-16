part of 'coin_detail_contract_view.dart';

class _HeatMapView extends StatefulWidget {
  const _HeatMapView({
    required this.logic,
  });

  final CoinDetailContractLogic logic;

  @override
  State<_HeatMapView> createState() => _HeatMapViewState();
}

class _HeatMapViewState extends State<_HeatMapView> {
  final isOi = false.obs;
  InAppWebViewController? webCtrl;

  @override
  Widget build(BuildContext context) {
    return AliveWidget(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Text(S.of(context).heat_map, style: Styles.tsBody_14m(context)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerTheme.color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Obx(() {
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            isOi.value = false;
                            _evaluate();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: isOi.value
                                  ? Colors.transparent
                                  : Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              S.of(context).s_24h_turnover,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: Styles.fontMedium,
                                  color: isOi.value
                                      ? Styles.cSub(context)
                                      : Styles.cBody(context)),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            isOi.value = true;
                            _evaluate();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: isOi.value
                                  ? Theme.of(context).scaffoldBackgroundColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(S.of(context).s_oi,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: Styles.fontMedium,
                                    color: isOi.value
                                        ? Styles.cBody(context)
                                        : Styles.cSub(context))),
                          ),
                        ),
                      ],
                    );
                  }),
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
    );
  }

  void _evaluate() {
    final dataParams = {
      'baseCoin': widget.logic.baseCoin,
      //币
      'productType': 'CONTRACT',
      // "SPOT"现货, "CONTRACT":合约
      'type': isOi.value ? 'oi' : 'vol'
      // vol: 成交量, oi: 持仓
    };
    final platformString = kIsWeb
        ? 'web'
        : Platform.isAndroid
            ? 'android'
            : 'ios';
    final dataParamsString = jsonEncode(dataParams);
    final localeString = jsonEncode({'locale': AppUtil.shortLanguageName});
    final jsSource = '''
        setChartData($dataParamsString, "$platformString", "tickerHeatMap", $localeString);    
                ''';
    webCtrl?.evaluateJavascript(source: jsSource);
  }
}
