import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../../widget/custom_bottom_sheet/custom_bottom_sheet_view.dart';

class LongShortPersonRatioLogic extends GetxController {
  final interval1 = '1h'.obs;
  final interval2 = '1h'.obs;

  InAppWebViewController? webCtrl1;
  InAppWebViewController? webCtrl2;

  Timer? _pollingTimer;
  bool refreshing = false;

  final loading = true.obs;

  String jsonData1 = '';
  String jsonData2 = '';

  @override
  void onInit() {
    // _startPolling();
    onRefresh();
    super.onInit();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      onRefresh();
    });
  }

  Future<void> onRefresh() async {
    refreshing = true;
    await Future.wait([loadChartData01(), loadChartData02()]).then((value) {
      if (loading.value == true) loading.value = false;
    }).whenComplete(() {
      refreshing = false;
    });
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  Future<void> loadChartData01() async {
    final json = await Apis().getLongShortPersonRatio(
        baseCoin: 'BTC',
        interval: interval1.value,
        exchangeName: 'Binance',
        type: 'USDT',
        exchangeType: 'USDT');
    jsonData1 = jsonEncode(json);
    updateChart01();
  }

  void updateChart01() {
    final options = {
      'exchangeName': 'Binance',
      'interval': interval1.value,
      'baseCoin': 'BTC',
      'locale': AppUtil.shortLanguageName,
      'price': S.current.s_price,
      'seriesLongName': S.current.s_longs,
      'seriesShortName': S.current.s_shorts,
      'ratioName': S.current.s_longshort_ratio,
    };
    var platformString = Platform.isAndroid ? 'android' : 'ios';
    var jsSource = '''
    setChartData($jsonData1, "$platformString", "longShortChart", ${jsonEncode(options)});    
    ''';
    webCtrl1?.evaluateJavascript(source: jsSource);
  }

  Future<void> loadChartData02() async {
    final json = await Apis().getLongShortPersonRatio(
        baseCoin: 'BTC',
        interval: interval2.value,
        exchangeName: 'Okex',
        type: '',
        exchangeType: '');
    jsonData2 = jsonEncode(json);
    updateChart02();
  }

  void updateChart02() {
    final options = {
      'exchangeName': 'Okex',
      'interval': interval2.value,
      'baseCoin': 'BTC',
      'locale': AppUtil.shortLanguageName,
      'price': S.current.s_price,
      'seriesLongName': S.current.s_longs,
      'seriesShortName': S.current.s_shorts,
      'ratioName': S.current.s_longshort_ratio,
    };
    var platformString = Platform.isAndroid ? 'android' : 'ios';
    var jsSource = '''
    setChartData($jsonData2, "$platformString", "longShortChart", ${jsonEncode(options)});    
    ''';
    webCtrl2?.evaluateJavascript(source: jsSource);
  }

  Future<String?> openSelector(String current) async {
    final result = await Get.bottomSheet(
      const CustomBottomSheetPage(),
      isScrollControlled: true,
      isDismissible: true,
      settings:  RouteSettings(
        arguments: {
          'title': S.current.s_choose_time,
          'list': const ['5m', '15m', '30m', '1h', '2h', '4h', '12h', '1d'],
          'current': current
        },
      ),
    );
    return result as String?;
  }
}
