import 'dart:convert';
import 'dart:io';

import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/custom_search_bottom_sheet/custom_search_bottom_sheet_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import 'liq_map_state.dart';

class LiqMapLogic extends GetxController {
  final LiqMapState state = LiqMapState();

  Future<void> chooseSymbol(bool isAgg) async {
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
          'list': isAgg ? state.coinList.toList() : state.symbolList.toList(),
          'current': isAgg ? state.aggCoin.value : state.symbol.value,
        },
      ),
    );

    if (result != null) {
      final v = result as String;
      if (isAgg) {
        if (state.aggCoin.value != v) {
          state.aggCoin.value = v;
          await getAggJsonData(isAgg: true);
        }
      } else {
        if (state.symbol.value != v) {
          state.symbol.value = v;
          await getJsonData(isAgg: false);
        }
      }
    }
  }

  Future<void> chooseTime(bool isAgg) async {
    final result = await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) {
        if (!kIsWeb && Platform.isIOS) {
          return PointerInterceptor(child: const CustomSearchBottomSheetPage());
        } else {
          return const CustomSearchBottomSheetPage();
        }
      },
      routeSettings: RouteSettings(
        arguments: {
          'title': S.current.s_choose_time,
          'list': const ['1d', '1w'],
          'current': isAgg ? state.aggInterval.value : state.interval.value,
        },
      ),
    );
    if (result != null) {
      final v = result as String;
      if (isAgg) {
        if (state.aggInterval.value != v) {
          state.aggInterval.value = v;
          await getAggJsonData(isAgg: true);
        }
      } else {
        if (state.interval.value != v) {
          state.interval.value = v;
          await getJsonData(isAgg: false);
        }
      }
    }
  }

  Future<void> onRefresh() async {
    if (state.refreshBCanPress) {
      state.refreshBCanPress = false;
      await getJsonData(isAgg: false);
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

  Future<void> getJsonData({bool showLoading = true, bool? isAgg}) async {
    if (showLoading) {
      Loading.show();
    }
    final data = await Apis()
        .getLiqMapJsonData(
          interval: state.interval.value,
          symbol: state.symbol.value.split('/').last,
          exchange: state.symbol.value.split('/').first,
        )
        .whenComplete(Loading.dismiss);
    final json = {'code': '1', 'success': true, 'data': data};
    final jsSource = _updateChartJs(jsonEncode(json), 'liqMap');
    updateReadyStatus(dataReady: true, evJS: jsSource, isAgg: isAgg);
  }

  String _updateChartJs(String jsData, String type) {
    final options = {
      'theme': StoreLogic.to.isDarkMode ? 'night' : 'light',
      'locale': AppUtil.shortLanguageName,
      'long': S.current.s_liq_map_long,
      'short': S.current.s_liq_map_short,
      'low': S.current.s_liq_map_low,
      'mid': S.current.s_liq_map_mid,
      'high': S.current.s_liq_map_high,
    };
    final platformString = kIsWeb
        ? 'web'
        : Platform.isAndroid
            ? 'android'
            : 'ios';
    final jsSource = '''
setChartData($jsData, "$platformString", "$type", ${jsonEncode(options)});    
    ''';
    return jsSource;
  }

  void updateReadyStatus(
      {bool? dataReady,
      bool? webReady,
      String? evJS,
      bool? aggDataReady,
      bool? aggWebReady,
      String? aggEvJS,
      bool? isAgg}) {
    state.readyStatus = (
      dataReady: dataReady ?? state.readyStatus.dataReady,
      webReady: webReady ?? state.readyStatus.webReady,
      evJS: evJS ?? state.readyStatus.evJS,
      aggDataReady: aggDataReady ?? state.readyStatus.aggDataReady,
      aggWebReady: aggWebReady ?? state.readyStatus.aggWebReady,
      aggEvJS: aggEvJS ?? state.readyStatus.aggEvJS
    );

    if (state.readyStatus.dataReady &&
        state.readyStatus.webReady &&
        (isAgg == false || isAgg == null)) {
      state.webCtrl?.evaluateJavascript(source: state.readyStatus.evJS);
    }
    if (state.readyStatus.aggDataReady &&
        state.readyStatus.aggWebReady &&
        (isAgg == true || isAgg == null)) {
      state.aggWebCtrl?.evaluateJavascript(source: state.readyStatus.aggEvJS);
    }
  }

  Future<void> onAggRefresh() async {
    if (state.aggRefreshBCanPress) {
      state.aggRefreshBCanPress = false;
      await getAggJsonData(isAgg: true);
      Future.delayed(const Duration(seconds: 5), () {
        state.aggRefreshBCanPress = true;
      });
    }
  }

  Future<void> getAggCoinData() async {
    final data = await Apis().getMarketAllCurrencyData();
    state.coinList.value = data ?? [];
    state.aggCoin.value = data?[0] ?? '';
  }

  Future<void> getAggJsonData({bool showLoading = true, bool? isAgg}) async {
    if (showLoading) {
      Loading.show();
    }
    final data = await Apis().getAggLiqMap(
      interval: state.aggInterval.value,
      baseCoin: state.aggCoin.value,
    );
    Loading.dismiss();
    final json = {'code': '1', 'success': true, 'data': data};
    final jsSource = _updateChartJs(jsonEncode(json), 'aggLiqMap');
    updateReadyStatus(aggDataReady: true, aggEvJS: jsSource, isAgg: isAgg);
  }

  @override
  Future<void> onReady() async {
    await Future.wait([getSymbolsData(), getAggCoinData()]);
    await Future.wait(
        [getJsonData(showLoading: false), getAggJsonData(showLoading: false)]);
    state.isLoading.value = false;
  }
}
