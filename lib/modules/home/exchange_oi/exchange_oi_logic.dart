import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ank_app/entity/oi_chart_menu_param_entity.dart';
import 'package:ank_app/entity/oi_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../widget/custom_bottom_sheet/custom_bottom_sheet_view.dart';

class ExchangeOiLogic extends GetxController {
  final menuParamEntity = OIChartMenuParamEntity(
    baseCoin: 'BTC',
    exchange: 'ALL',
    type: 'USD',
    interval: '1d',
  ).obs;
  final oiList = RxList<OIEntity>();
  final coinList = RxList<String>();
  var selectedCoinIndex = 0;
  String? jsonData;
  InAppWebViewController? webCtrl;
  final itemScrollController = ItemScrollController();
  StreamSubscription? _fgbgSubscription;
  var isAppVisible = true;
  final loading = true.obs;
  var refreshing = false;
  var webViewLoaded = false;
  @override
  void onInit() {
    _fgbgSubscription = FGBGEvents.stream.listen((event) {
      isAppVisible = event == FGBGType.foreground;
    });
    Future.wait([loadData(), loadOIData(), loadAllBaseCoins()]).then((value) {
      loading.value = false;
    });
    startPolling();
    super.onInit();
  }

  Timer? _pollingTimer;

  void startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!isAppVisible) return;
      onRefresh();
    });
  }

  @override
  void onClose() {
    _fgbgSubscription?.cancel();
    _pollingTimer?.cancel();
  }

  Future onRefresh() {
    refreshing = true;
    return Future.wait([loadData(), loadOIData()]).whenComplete(() {
      refreshing = false;
    });
  }

  Future<void> loadAllBaseCoins() async {
    final result = await Apis().getMarketAllCurrencyData();
    coinList.assignAll(result ?? []);
  }

  Future<void> loadData() async {
    final result = await Apis()
        .getExchangeIOList(baseCoin: menuParamEntity.value.baseCoin);
    oiList.assignAll(result ?? []);
  }

  Future<void> loadOIData() async {
    final t1 = DateTime.now().millisecondsSinceEpoch;
    final result = await Apis().getExchangeOIChartJson(
        baseCoin: menuParamEntity.value.baseCoin,
        interval: menuParamEntity.value.interval,
        type: menuParamEntity.value.type);
    final json = {'code': '1', 'success': true, 'data': result};
    jsonData = jsonEncode(json);
    updateChart();
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
    };
    var platformString = Platform.isAndroid ? 'android' : 'ios';
    var jsSource = '''
setChartData($jsonData, "$platformString", "openInterest", ${jsonEncode(options)});    
    ''';
    webCtrl?.evaluateJavascript(source: jsSource);
  }

  Future<void> toSearch() async {
    final result = await Get.toNamed(RouteConfig.contractMarketSearch,
        arguments: coinList.toList());
    if (result != null) {
      String type = result as String;
      selectedCoinIndex = coinList.indexOf(type);
      menuParamEntity.value.baseCoin = type;
      coinList.refresh();
      itemScrollController.scrollTo(
        index: selectedCoinIndex,
        alignment: 0.5,
        duration: const Duration(milliseconds: 500),
      );
      Loading.wrap(() => onRefresh());
    }
  }

  Future<String?> openSelector(List<String> items) async {
    final result = await Get.bottomSheet(
      CustomBottomSheetPage(),
      isScrollControlled: true,
      isDismissible: true,
      settings: RouteSettings(
        arguments: {'title': '', 'list': items, 'current': ''},
      ),
    );
    return result as String?;
  }

  final exchangeItems = const [
    'ALL', 'Binance', 'Okex', 'Bybit', 'CME', 'Bitget', 'Bitmex', //end
    'Bitfinex', 'Gate', 'Deribit', 'Huobi', 'Kraken' //end
  ];
  final intervalItems = const ['15m', '30m', '1h', '2h', '4h', '12h', '1d'];
}
