import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/custom_search_bottom_sheet/custom_search_bottom_sheet_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import 'liq_hot_map_state.dart';

class LiqHotMapLogic extends GetxController {
  final LiqHotMapState state = LiqHotMapState();

  Future<void> chooseSymbol() async {
    final result = await showModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        if (!kIsWeb && Platform.isIOS) {
          return PointerInterceptor(child: const CustomSearchBottomSheetPage());
        } else {
          return const CustomSearchBottomSheetPage();
        }
      },
      isScrollControlled: true,
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

  Future<void> chooseTime() async {
    final result = await showModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        if (!kIsWeb && Platform.isIOS) {
          return PointerInterceptor(child: const CustomSearchBottomSheetPage());
        } else {
          return const CustomSearchBottomSheetPage();
        }
      },
      isScrollControlled: true,
      routeSettings: RouteSettings(
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

  Future<void> onRefresh() async {
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

  void _updateChart() {
    final dataParams = {
      'symbol': state.symbol.value,
      'interval': state.interval.value,
    };
    final options = {
      'theme': StoreLogic.to.isDarkMode ? 'night' : 'light',
      'locale': AppUtil.shortLanguageName,
      'price': S.current.s_price,
      'liqHeat': S.current.liqHeat,
      'liqHeatMap': S.current.s_liq_hot_map,
    };
    final platformString = kIsWeb
        ? 'web'
        : Platform.isAndroid
            ? 'android'
            : 'ios';
    final jsSource = '''
setChartData(${jsonEncode(dataParams)}, "$platformString", "liqHeatMap", ${jsonEncode(options)});    
    ''';
    state.isLoading.value = false;
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

  @override
  void onReady() {
    getSymbolsData();
  }
}
