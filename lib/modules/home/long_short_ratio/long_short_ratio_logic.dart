import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/custom_bottom_sheet/custom_bottom_sheet_view.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'long_short_ratio_state.dart';

class LongShortRatioLogic extends GetxController {
  final LongShortRatioState state = LongShortRatioState();

  Future<void> tapHeader(String type) async {
    if (type == state.type.value) return;
    state.type.value = type;
    await onRefresh(true);
  }

  Future<void> toSearch() async {
    final result = await Get.toNamed(RouteConfig.contractMarketSearch,
        arguments: state.headerTitles);
    if (result != null) {
      final type = result as String;
      state.type.value = type;
      state.itemScrollController.scrollTo(
        index: state.headerTitles.indexOf(type),
        alignment: 0.5,
        duration: const Duration(milliseconds: 200),
      );
      await onRefresh(true);
    }
  }

  Future<void> chooseTime(bool isHeader) async {
    final result = await Get.bottomSheet(
      CustomSelector(
        title: S.current.s_choose_time,
        dataList: const ['5m', '15m', '30m', '1h', '2h', '4h', '12h', '1d'],
        current: isHeader ? state.longSortTime.value : state.webTime.value,
      ),
      isScrollControlled: true,
    );
    if (result != null) {
      final v = result as String;
      if (isHeader) {
        if (state.longSortTime.value != v) {
          state.longSortTime.value = v;
          await getData(true);
        }
      } else {
        if (state.webTime.value != v) {
          state.webTime.value = v;
          await getJSData(true);
          _updateChart();
        }
      }
    }
  }

  Future<void> getAllData() async {
    await Future.wait<dynamic>([
      getHeaderData(),
      getData(false),
      getJSData(false),
    ]).then((value) {
      state.isLoading.value = false;
      _updateChart();
    });
  }

  Future<void> onRefresh(bool isLoading) async {
    if (isLoading) {
      Loading.show();
    }
    state.isRefresh = true;
    await Future.wait<dynamic>([
      getData(false),
      if (isLoading) getJSData(false),
    ]).then((value) {
      Loading.dismiss();
      state.isRefresh = false;
      _updateChart();
    });
  }

  Future<void> getHeaderData() async {
    final data = await Apis().getMarketAllCurrencyData();
    state.headerTitles.value = data ?? [];
  }

  Future<void> getData(bool isLoading) async {
    if (isLoading) {
      Loading.show();
    }
    final data = await Apis().getShortRateData(
        interval: state.longSortTime.value, baseCoin: state.type.value);
    data
        ?.where((element) => element.exchangeName == 'Okex')
        .forEach((e) => e.exchangeName = 'Okx');
    state.dataList.value = data ?? [];
    Loading.dismiss();
  }

  Future<void> getJSData(bool isLoading) async {
    if (isLoading) {
      Loading.show();
    }
    final data = await Apis().getShortRateJSData(
        interval: state.webTime.value,
        baseCoin: state.type.value,
        exchangeName: 'Binance');
    state.jsData = data;
    Loading.dismiss();
  }

  void _updateChart() {
    final json = {'code': '1', 'success': true, 'data': state.jsData};
    final options = {
      'exchangeName': state.jsData?.exchangeName,
      'interval': state.webTime.value,
      'baseCoin': state.type.value,
      'locale': AppUtil.shortLanguageName,
      'price': S.current.s_price,
      'seriesLongName': S.current.s_longs,
      'seriesShortName': S.current.s_shorts,
      'ratioName': S.current.s_longshort_ratio,
    };
    final platformString = kIsWeb
        ? 'web'
        : Platform.isAndroid
            ? 'android'
            : 'ios';
    final jsSource = '''
setChartData(${jsonEncode(json)}, "$platformString", "realtimeLongShort", ${jsonEncode(options)});    
    ''';
    updateReadyStatus(dataReady: true, evJS: jsSource);
  }

  void updateReadyStatus({bool? dataReady, bool? webReady, String? evJS}) {
    state.readyStatus = (
      dataReady: dataReady ?? state.readyStatus.dataReady,
      webReady: webReady ?? state.readyStatus.webReady,
      evJS: evJS ?? state.readyStatus.evJS
    );
    if (state.readyStatus.dataReady && state.readyStatus.webReady) {
      state.webCtrl?.evaluateJavascript(source: state.readyStatus.evJS);
    }
  }

  Future<void> _startTimer() async {
    state.pollingTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!state.isRefresh && AppConst.canRequest) {
        await onRefresh(false);
      }
    });
  }

  @override
  void onReady() {
    getAllData();
  }

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  @override
  void onClose() {
    state.pollingTimer?.cancel();
    state.pollingTimer = null;
    super.onClose();
  }
}
