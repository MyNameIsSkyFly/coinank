part of 'coin_detail_contract_view.dart';

class _ChartLiqView extends StatefulWidget {
  const _ChartLiqView({
    required this.logic,
  });

  final CoinDetailContractLogic logic;

  @override
  State<_ChartLiqView> createState() => _ChartLiqViewState();
}

class _ChartLiqViewState extends State<_ChartLiqView> {
  final menuParamEntity = OIChartMenuParamEntity(
    baseCoin: 'BTC',
    exchange: 'ALL',
    interval: '1d',
  ).obs;
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
      'theme': StoreLogic.to.isDarkMode ? 'night' : 'light'
    };
    var platformString = Platform.isAndroid ? 'android' : 'ios';
    var jsSource = '''
setChartData($jsonData, "$platformString", "liqStatistic", ${jsonEncode(options)});    
    ''';
    updateReadyStatus(dataReady: true, evJS: jsSource);
    // webCtrl?.evaluateJavascript(source: jsSource);
  }

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
    final result = await Apis().getLiqStatistic(
      menuParamEntity.value.baseCoin ?? '',
      interval: menuParamEntity.value.interval,
    );
    jsonData = jsonEncode(result);
    updateChart();
  }

  final intervalItems = const ['15m', '30m', '1h', '2h', '4h', '12h', '1d'];
  double? _height = 1000;
  @override
  Widget build(BuildContext context) {
    return AliveWidget(
      child: SingleChildScrollView(
        child: SizedBox(
          height: _height,
          child: CommonWebView(
            url: Urls.urlLiquidation,
            enableZoom: true,
            onLoadStop: (controller) {
              updateReadyStatus(webReady: true);
              Future.delayed(const Duration(seconds: 1)).then((value) {
                controller.getContentHeight().then((value) => setState(() {
                      print('value==============$value');
                      _height = value?.toDouble();
                    }));
              });
            },
            onWebViewCreated: (controller) {
              webCtrl = controller;
            },
          ),
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
