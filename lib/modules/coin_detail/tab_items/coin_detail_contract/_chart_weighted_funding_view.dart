part of 'coin_detail_contract_view.dart';

class _ChartWeightedFundingView extends StatefulWidget {
  const _ChartWeightedFundingView({
    required this.logic,
  });

  final CoinDetailContractLogic logic;

  @override
  State<_ChartWeightedFundingView> createState() =>
      _ChartWeightedFundingViewState();
}

class _ChartWeightedFundingViewState extends State<_ChartWeightedFundingView> {
  final menuParamEntity = OIChartMenuParamEntity(
    baseCoin: 'BTC',
    exchange: 'ALL',
    interval: '1d',
  ).obs;
  final type = RxString(S.current.oiWeightedFundingRate);
  String? jsonData;
  ({bool dataReady, bool webReady, String evJS}) readyStatus =
      (dataReady: false, webReady: false, evJS: '');
  InAppWebViewController? webCtrl;

  @override
  void initState() {
    menuParamEntity.value.baseCoin = widget.logic.baseCoin;
    loadData();
    super.initState();
  }

  void updateChart() {
    final options = {
      'interval': menuParamEntity.value.interval,
      'baseCoin': menuParamEntity.value.baseCoin,
      'locale': AppUtil.shortLanguageName,
      'theme': StoreLogic.to.isDarkMode ? 'night' : 'light',
      'frType': typeMap[type.value], //fr-oi 持仓加权, fr-vol 成交量加权
    };
    var platformString = Platform.isAndroid ? 'android' : 'ios';
    var jsSource = '''
setChartData($jsonData, "$platformString", "weightFundingRate", ${jsonEncode(options)});    
    ''';
    updateReadyStatus(dataReady: true, evJS: jsSource);
    // webCtrl?.evaluateJavascript(source: jsSource);
  }

  Future<String?> openSelector(List<String> items) async {
    final result = await showCupertinoModalPopup(
      context: context,
      builder: (context) =>
          SelectorSheetWithInterceptor(title: '', dataList: items),
      barrierColor: Colors.black26,
    );

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

  Future<void> loadData() async {
    final result = await Apis().getWeightFundingRate(
      menuParamEntity.value.baseCoin ?? '',
      interval: menuParamEntity.value.interval,
      size: 180,
      endTime: DateTime.now().millisecondsSinceEpoch,
    );
    final json = {'code': '1', 'success': 'true', 'data': result};
    jsonData = jsonEncode(json);
    updateChart();
  }

  final intervalItems = const ['15m', '30m', '1h', '2h', '4h', '12h', '1d'];

  final typeItems = [
    S.current.oiWeightedFundingRate,
    S.current.volWeightedFundingRate
  ];
  final typeText = RxString('initial');
  final typeMap = {
    S.current.oiWeightedFundingRate: 'fr-oi',
    S.current.volWeightedFundingRate: 'fr-vol',
  };

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
            Obx(() {
              return Row(
                children: [
                  const Gap(15),
                  Expanded(
                    child: Text(
                      '${S.of(context).weightedFundingRate} (${menuParamEntity.value.baseCoin})',
                      style: Styles.tsBody_14m(context),
                    ),
                  ),
                  const Gap(10),
                  _filterChip(context, onTap: () async {
                    final result = await openSelector(intervalItems);
                    if (result != null &&
                        result.toLowerCase() !=
                            menuParamEntity.value.interval?.toLowerCase()) {
                      menuParamEntity.value.interval = result;
                      loadData();
                      menuParamEntity.refresh();
                    }
                  }, text: menuParamEntity.value.interval),
                  const Gap(10),
                  _filterChip(context, onTap: () async {
                    final result = await openSelector(typeItems);
                    if (result != null &&
                        result.toLowerCase() != type.toLowerCase()) {
                      type.value = result;
                      loadData();
                    }
                  }, text: type.value),
                  const Gap(15),
                ],
              );
            }),
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
