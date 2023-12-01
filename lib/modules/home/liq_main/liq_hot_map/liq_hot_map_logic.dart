import 'dart:convert';
import 'dart:io';

import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/custom_bottom_sheet/custom_bottom_sheet_view.dart';
import 'package:ank_app/widget/custom_search_bottom_sheet/custom_search_bottom_sheet_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'liq_hot_map_state.dart';

class LiqHotMapLogic extends GetxController {
  final LiqHotMapState state = LiqHotMapState();

  chooseSymbol() async {
    final result = await showModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return const CustomSearchBottomSheetPage();
      },
      isScrollControlled: true,
      isDismissible: true,
      routeSettings: RouteSettings(
        arguments: {
          'list': state.symbolList.toList(),
          'current': state.symbol.value,
        },
      ),
    );
    if (result != null) {
      final v = result as String;
      if (state.symbol.value != v) {
        state.symbol.value = v;
        _updateChart();
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
          'list': const ['12h', '1d', '3d', '1w', '2w', '1M', '3M', '6M', '1Y'],
          'current': state.interval.value,
        },
      ),
    );
    if (result != null) {
      final v = result as String;
      if (state.interval.value != v) {
        state.interval.value = v;
        _updateChart();
      }
    }
  }

  onRefresh() async {
    if (state.refreshBCanPress) {
      state.refreshBCanPress = false;
      _updateChart();
      Future.delayed(const Duration(seconds: 5), () {
        state.refreshBCanPress = true;
      });
    }
  }

  Future<void> getSymbolsData() async {
    final data = await Apis().getLiqHeatMapData();
    state.symbolList.value = data ?? [];
    state.symbol.value = data?[0] ?? '';
    _updateChart();
  }

  _updateChart() async {
    final dataParams = {
      'symbol': state.symbol.value,
      'interval': state.interval.value,
    };
    final options = {
      'theme': StoreLogic.to.isDarkMode ??
          Get.mediaQuery.platformBrightness == Brightness.dark
          ? 'night'
          : 'light',
      'locale': AppUtil.shortLanguageName,
      'price': S.current.s_price,
      'liqHeat': S.current.liqHeat,
      'liqHeatMap': S.current.s_liq_hot_map,
    };
    var platformString = Platform.isAndroid ? 'android' : 'ios';
    var jsSource = '''
setChartData(${jsonEncode(
        dataParams)}, "$platformString", "liqHeatMap", ${jsonEncode(options)});    
    ''';
    await state.webCtrl
        ?.evaluateJavascript(source: jsSource);
    state.isLoading.value = false;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await getSymbolsData();
  }
}
