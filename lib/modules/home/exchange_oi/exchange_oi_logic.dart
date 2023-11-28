import 'dart:convert';
import 'dart:io';

import 'package:ank_app/entity/oi_chart_menu_param_entity.dart';
import 'package:ank_app/entity/oi_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class ExchangeOiLogic extends GetxController {
  final menuParamEntity = OIChartMenuParamEntity(
    baseCoin: 'BTC',
    exchange: 'ALL',
    type: 'USD',
    interval: '1d',
  ).obs;
  final oiList = RxList<OIEntity>();
  String? jsonData;
  InAppWebViewController? webCtrl;

  @override
  void onInit() {
    initData();
    loadOIData();
    super.onInit();
  }

  void initData() {}

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
}
