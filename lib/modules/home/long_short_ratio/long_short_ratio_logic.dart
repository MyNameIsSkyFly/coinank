import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/custom_bottom_sheet/custom_bottom_sheet_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'long_short_ratio_state.dart';

class LongShortRatioLogic extends FullLifeCycleController
    with FullLifeCycleMixin {
  final LongShortRatioState state = LongShortRatioState();

  tapHeader(String type) async {
    if (type == state.type.value) return;
    state.type.value = type;
    await onRefresh(true);
  }

  toSearch() async {
    final result = await Get.toNamed(RouteConfig.contractMarketSearch,
        arguments: state.headerTitles);
    if (result != null) {
      String type = result as String;
      state.type.value = type;
      state.itemScrollController.scrollTo(
        index: state.headerTitles.indexOf(type),
        alignment: 0.5,
        duration: const Duration(milliseconds: 500),
      );
      await onRefresh(true);
    }
  }

  chooseTime(bool isHeader) async {
    final result = await Get.bottomSheet(
      CustomBottomSheetPage(),
      isScrollControlled: true,
      isDismissible: true,
      settings: RouteSettings(
        arguments: {
          'title': '选择时间',
          'list': const ['5m', '15m', '30m', '1h', '2h', '4h', '12h', '1d'],
          'current': isHeader ? state.longSortTime.value : state.webTime.value,
        },
      ),
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
        }
      }
    }
  }

  Future<void> getAllData() async {
    await Future.wait([
      getHeaderData(),
      getData(false),
      getJSData(false),
    ]).then((value) {
      state.isLoading.value = false;
    });
  }

  Future<void> onRefresh(bool isLoading) async {
    if (isLoading) {
      Loading.show();
    }
    state.isRefresh = true;
    await Future.wait([
      getData(false),
      getJSData(false),
    ]).then((value) {
      Loading.dismiss();
      state.isRefresh = false;
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
    Loading.dismiss();
    final json = {'code': '1', 'success': true, 'data': data};
    final options = {
      'exchangeName': data?.exchangeName,
      'interval': state.webTime.value,
      'baseCoin': state.type.value,
      'locale': AppUtil.shortLanguageName,
      'price': S.current.s_price,
      'seriesLongName': S.current.s_longs,
      'seriesShortName': S.current.s_shorts,
      'ratioName': S.current.s_longshort_ratio,
    };
    var platformString = Platform.isAndroid ? 'android' : 'ios';
    var jsSource = '''
setChartData(${jsonEncode(json)}, "$platformString", "realtimeLongShort", ${jsonEncode(options)});    
    ''';
    state.webCtrl?.evaluateJavascript(source: jsSource);
  }

  Future<void> _startTimer() async {
    state.pollingTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!state.isRefresh && state.appVisible) {
        await onRefresh(false);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    getAllData();
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    state.pollingTimer?.cancel();
    state.pollingTimer = null;
    super.onClose();
  }

  @override
  void onDetached() {}

  @override
  void onHidden() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {
    //应用程序不可见，后台
    state.appVisible = false;
  }

  @override
  void onResumed() {
    //应用程序可见，前台
    state.appVisible = true;
  }
}
