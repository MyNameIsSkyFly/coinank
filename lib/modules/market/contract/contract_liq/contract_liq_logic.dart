import 'dart:convert';
import 'dart:io';

import 'package:ank_app/entity/liq_all_exchange_entity.dart';
import 'package:ank_app/http/apis.dart';
import 'package:ank_app/modules/coin_detail/widgets/coin_detail_selector_view.dart';
import 'package:ank_app/route/router_config.dart';
import 'package:ank_app/util/app_util.dart';
import 'package:ank_app/util/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ContractLiqLogic extends GetxController {
  late bool canSelectCoin;
  final itemScrollController = ItemScrollController();

  final selectedCoin = RxnString();
  final coinList = RxList<String>();

  final exchangeIntervals = RxList<LiqAllExchangeEntity>();
  final exchangeIntervalTops = RxList<LiqAllExchangeTopEntity>();
  final allExchanges = RxList<LiqAllExchangeEntity>();
  final topSymbols = RxList<LiqAllExchangeEntity>();
  final orders = RxList<LiqOrderEntity>();

  final totalLiqTraders = 0.obs;
  final filterAllExchangeInterval = '1h'.obs;
  final filterTopSymbolInterval = '1h'.obs;

  final filterOrderExchangeName = RxnString();
  final filterOrderAmount = Rxn<(int?, String?)>();
  final filterHeatMapInterval = RxString('1d');

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() => onRefresh();

  void onRefresh() {
    loadAllBaseCoins();
    loadAllExchangeInterval();
    loadAllExchanges();
    loadTopLiqSymbols();
    loadLiqOrders();
    loadHeatMapData();
  }

  Future<void> loadAllBaseCoins() async {
    final result = await Apis().getMarketAllCurrencyData();
    result?.insert(0, 'ALL');
    var list = result ?? [];
    coinList.assignAll(list);
  }

  Future<void> loadAllExchangeInterval() async {
    final result =
        await Apis().getLiqAllExchangeIntervals(baseCoin: selectedCoin.value);
    totalLiqTraders.value = result?.ext?.total ?? 0;
    exchangeIntervals.assignAll(result?.data ?? []);
    exchangeIntervalTops.assignAll(result?.ext?.tops ?? []);
  }

  Future<void> loadAllExchanges() async {
    final result = await Apis().getLiqAllExchange(
        baseCoin: selectedCoin.value,
        interval: filterAllExchangeInterval.value);
    allExchanges.assignAll(result ?? []);
  }

  Future<void> loadTopLiqSymbols() async {
    final result =
        await Apis().getLiqTopCoin(interval: filterTopSymbolInterval.value);
    topSymbols.assignAll(result ?? []);
  }

  Future<void> loadLiqOrders() async {
    final result = await Apis().getLiqOrders(
      baseCoin: selectedCoin.value,
      exchangeName: filterOrderExchangeName.value,
      amount: filterOrderAmount.value?.$1,
    );
    orders.assignAll(result ?? []);
  }

  Future<void> toSearch() async {
    final result = await Get.toNamed(RouteConfig.contractMarketSearch,
        arguments: coinList.toList());
    if (result != null) {
      final type = result as String;
      selectedCoin.value = type;
      int selectedCoinIndex = coinList.indexOf(type);
      coinList.refresh();
      itemScrollController.jumpTo(index: selectedCoinIndex, alignment: 0.2);
      onRefresh();
    }
  }

  ({bool dataReady, bool webReady, String evJS}) readyStatus =
      (dataReady: false, webReady: false, evJS: '');
  String? jsonData;
  InAppWebViewController? webCtrl;

  void updateChart() {
    final options = {
      'interval': filterHeatMapInterval.value,
      'baseCoin': selectedCoin.value,
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

  Future<String?> openHeatMapSelector() async {
    final result = await showCupertinoModalPopup(
      context: Get.context!,
      builder: (context) => const SelectorSheetWithInterceptor(
          title: '', dataList: ['15m', '30m', '1h', '2h', '4h', '12h', '1d']),
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

  Future<void> loadHeatMapData() async {
    final result = await Apis().getLiqStatistic(
      selectedCoin.value ?? '',
      interval: filterHeatMapInterval.value,
    );
    jsonData = jsonEncode(result);
    updateChart();
  }
}
