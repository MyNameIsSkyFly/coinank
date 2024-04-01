part of 'coin_detail_contract_view.dart';

class _ExchangeOiView extends StatefulWidget {
  const _ExchangeOiView({
    required this.logic,
  });

  final CoinDetailContractLogic logic;

  @override
  State<_ExchangeOiView> createState() => _ExchangeOiViewState();
}

class _ExchangeOiViewState extends State<_ExchangeOiView> {
  final menuParamEntity = OIChartMenuParamEntity(
    baseCoin: 'BTC',
    exchange: 'ALL',
    type: 'USD',
    interval: '1d',
  ).obs;
  final oiList = RxList<OIEntity>();
  String? jsonData;
  var refreshing = false;
  ({bool dataReady, bool webReady, String evJS}) readyStatus =
      (dataReady: false, webReady: false, evJS: '');
  InAppWebViewController? webCtrl;

  @override
  void initState() {
    menuParamEntity.value.baseCoin = widget.logic.baseCoin;
    loadOIData();
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    final result = await Apis()
        .getExchangeIOList(baseCoin: menuParamEntity.value.baseCoin);
    result
        ?.where((element) => element.exchangeName == 'Okex')
        .forEach((e) => e.exchangeName = 'Okx');
    oiList.assignAll(result ?? []);
  }

  void updateChart() {
    if (!(menuParamEntity.value.type?.toUpperCase() == 'USD')) {
      menuParamEntity.update((val) {
        val?.type = menuParamEntity.value.baseCoin;
      });
    }
    var exchange = menuParamEntity.value.exchange;
    if (exchange?.toUpperCase() == 'ALL') {
      exchange = '';
    }

    final options = {
      'exchangeName': exchange,
      'interval': menuParamEntity.value.interval,
      'baseCoin': menuParamEntity.value.baseCoin,
      'locale': AppUtil.shortLanguageName,
      'price': S.current.s_price,
      //Bar/Line
      'viewType': chartIndex.value == 0 ? 'Line' : 'Bar',
      'theme': StoreLogic.to.isDarkMode ? 'night' : 'light'
    };
    var platformString = Platform.isAndroid ? 'android' : 'ios';
    var jsSource = '''
setChartData($jsonData, "$platformString", "openInterest", ${jsonEncode(options)});    
    ''';
    updateReadyStatus(dataReady: true, evJS: jsSource);
    // webCtrl?.evaluateJavascript(source: jsSource);
  }

  Future<String?> openSelector(List<String> items) async {
    var result = await showCupertinoModalPopup(
      context: context,
      builder: (context) =>
          SelectorSheetWithInterceptor(title: '', dataList: items),
      barrierDismissible: true,
      barrierColor: Colors.black26,
    );
    result = result == 'Okx' ? 'Okex' : result;
    return result as String?;
  }

  void updateReadyStatus({bool? dataReady, bool? webReady, String? evJS}) {
    readyStatus = (
      dataReady: dataReady ?? readyStatus.dataReady,
      webReady: webReady ?? readyStatus.webReady,
      evJS: evJS ?? readyStatus.evJS
    );
    if (readyStatus.dataReady && readyStatus.webReady) {
      webCtrl?.evaluateJavascript(source: readyStatus.evJS);
    }
  }

  Future<void> loadOIData() async {
    final result = await Apis().getChartJson(
        baseCoin: menuParamEntity.value.baseCoin,
        interval: menuParamEntity.value.interval,
      type: menuParamEntity.value.type,
      size: null,
    );
    final json = {'code': '1', 'success': true, 'data': result};
    jsonData = jsonEncode(json);
    updateChart();
  }

  final exchangeItems = const [
    'ALL', 'Binance', 'Okx', 'Bybit', 'CME', 'Bitget', 'Bitmex', //end
    'Bitfinex', 'Gate', 'Deribit', 'Huobi', 'Kraken' //end
  ];
  final intervalItems = const ['15m', '30m', '1h', '2h', '4h', '12h', '1d'];
  final chartTypes = [S.current.areaChart, S.current.barChart];
  final chartIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return AliveWidget(
      child: OverflowBox(
        minHeight: 515,
        maxHeight: 515,
        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            const Gap(15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    '${S.of(context).s_exchange_oi}(${menuParamEntity.value.baseCoin})',
                    style: Styles.tsBody_14m(context),
                  ),
                ),
                const Gap(10),
                Obx(() {
                  return Row(
                    children: [
                      const Gap(15),
                      _filterChip(context, onTap: () async {
                        final result = await openSelector(exchangeItems);
                        if (result != null &&
                            result.toLowerCase() !=
                                menuParamEntity.value.exchange?.toLowerCase()) {
                          menuParamEntity.value.exchange = result;
                          updateChart();
                          menuParamEntity.refresh();
                        }
                      }, text: menuParamEntity.value.exchange),
                      const Gap(10),
                      _filterChip(context, onTap: () async {
                        final result = await openSelector(intervalItems);
                        if (result != null &&
                            result.toLowerCase() !=
                                menuParamEntity.value.interval?.toLowerCase()) {
                          menuParamEntity.value.interval = result;
                          loadOIData();
                          menuParamEntity.refresh();
                        }
                      }, text: menuParamEntity.value.interval),
                      const Gap(10),
                      _filterChip(context, onTap: () async {
                        final result = await openSelector([
                          'USD',
                          menuParamEntity.value.baseCoin ?? '',
                        ]);
                        if (result != null &&
                            result.toLowerCase() !=
                                menuParamEntity.value.type?.toLowerCase()) {
                          menuParamEntity.value.type = result;
                          loadOIData();
                          menuParamEntity.refresh();
                        }
                      }, text: menuParamEntity.value.type),
                      const Gap(10),
                      _filterChip(context, onTap: () async {
                        final result = await openSelector(chartTypes);
                        if (result != null &&
                            result != chartTypes[chartIndex.value]) {
                          chartIndex.value = chartTypes.indexOf(result);
                          updateChart();
                        }
                      }, text: chartTypes[chartIndex.value]),
                      const Gap(15),
                    ],
                  );
                }),
              ],
            ),
            Container(
              height: 400,
              width: double.infinity,
              margin: const EdgeInsets.all(15),
              child: CommonWebView(
                url: Urls.chartUrl,
                enableZoom: true,
                onLoadStop: (controller) => updateReadyStatus(webReady: true),
                onWebViewCreated: (controller) {
                  webCtrl = controller;
                },
              ),
            ),
          ],
        ),
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
}
