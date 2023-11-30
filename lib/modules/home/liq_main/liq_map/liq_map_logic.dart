import 'dart:convert';
import 'dart:io';

import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/custom_bottom_sheet/custom_bottom_sheet_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'liq_map_state.dart';

class LiqMapLogic extends GetxController {
  final LiqMapState state = LiqMapState();

  chooseSymbol() async {
    final result = await Get.bottomSheet(
      const CustomBottomSheetPage(),
      isScrollControlled: true,
      isDismissible: true,
      settings: RouteSettings(
        arguments: {
          'title': S.current.s_choose_coin,
          'list': state.symbolList.toList(),
          'current': state.symbol.value,
        },
      ),
    );
    if (result != null) {
      final v = result as String;
      if (state.symbol.value != v) {
        state.symbol.value = v;
        await getJsonData(true);
      }
    }
  }

  chooseTime() async {
    final result = await Get.bottomSheet(
      const CustomBottomSheetPage(),
      isScrollControlled: true,
      isDismissible: true,
      settings: RouteSettings(
        arguments: {
          'title': S.current.s_choose_time,
          'list': const ['1d', '1w'],
          'current': state.interval.value,
        },
      ),
    );
    if (result != null) {
      final v = result as String;
      if (state.interval.value != v) {
        state.interval.value = v;
        await getJsonData(true);
      }
    }
  }

  onRefresh() async {
    if (state.refreshBCanPress) {
      state.refreshBCanPress = false;
      await getJsonData(true);
      Future.delayed(const Duration(seconds: 5), () {
        state.refreshBCanPress = true;
      });
    }
  }

  Future<void> getSymbolsData() async {
    final data = await Apis().getLiqMapData();
    state.symbolList.value = data ?? [];
    state.symbol.value = data?[0] ?? '';
  }

  Future<void> getJsonData(bool showLoading) async {
    if (showLoading) {
      Loading.show();
    }
    final data = await Apis().getLiqMapJsonData(
      interval: state.interval.value,
      symbol: state.symbol.value.split('/').last,
      exchange: state.symbol.value.split('/').first,
    );
    Loading.dismiss();
    final json = {'code': '1', 'success': true, 'data': data};
    _updateChart(jsonEncode(json));
  }

  void _updateChart(String jsData) {
    final options = {
      'theme': StoreLogic.to.isDarkMode ??
              Get.mediaQuery.platformBrightness == Brightness.dark
          ? 'night'
          : 'light',
      'locale': AppUtil.shortLanguageName,
      'long': S.current.s_liq_map_long,
      'short': S.current.s_liq_map_short,
      'low': S.current.s_liq_map_low,
      'mid': S.current.s_liq_map_mid,
      'high': S.current.s_liq_map_high,
    };
    var platformString = Platform.isAndroid ? 'android' : 'ios';
    var jsSource = '''
setChartData($jsData, "$platformString", "liqMap", ${jsonEncode(options)});    
    ''';
    state.webCtrl?.evaluateJavascript(source: jsSource);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await getSymbolsData();
    await getJsonData(false);
    state.isLoading.value = false;
  }
}
