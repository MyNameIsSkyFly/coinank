import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/modules/coin_detail/coin_detail_logic.dart';
import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_hold/coin_detail_hold_logic.dart';
import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_hold/widget/_event.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:ank_app/widget/custom_bottom_sheet/custom_bottom_sheet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class HoldChartView extends StatefulWidget {
  const HoldChartView({
    super.key,
    required this.logic,
  });

  final CoinDetailHoldLogic logic;

  @override
  State<HoldChartView> createState() => _HoldChartViewState();
}

class _HoldChartViewState extends State<HoldChartView> {
  String? jsonData;
  ({bool dataReady, bool webReady, String evJS}) readyStatus =
      (dataReady: false, webReady: false, evJS: '');
  InAppWebViewController? webCtrl;
  StreamSubscription? _subscription;

  @override
  void initState() {
    _subscription = AppConst.eventBus.on<EventHoldLoaded>().listen((event) {
      final json = {
        'code': 200,
        'success': true,
        'data': event.holdAddressEntity?.toJson()
      };
      jsonData = jsonEncode(json);
      updateChart();
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void updateChart() {
    final options = {
      'baseCoin': widget.logic.baseCoin,
      'locale': AppUtil.shortLanguageName,
    };
    var platformString = Platform.isAndroid ? 'android' : 'ios';
    var jsSource = '''
setChartData($jsonData, "$platformString", "holderAddress", ${jsonEncode(options)});    
    ''';
    updateReadyStatus(dataReady: true, evJS: jsSource);
    // webCtrl?.evaluateJavascript(source: jsSource);
  }

  RxBool get showInterceptor => Get.find<CoinDetailLogic>().s1howInterceptor;

  Future<String?> openSelector(List<String> items) async {
    showInterceptor.value = true;
    final result = await Get.bottomSheet(
      const CustomBottomSheetPage(),
      isScrollControlled: true,
      isDismissible: true,
      barrierColor: Colors.black26,
      settings: RouteSettings(
        arguments: {'title': '', 'list': items, 'current': ''},
      ),
    );
    showInterceptor.value = false;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 400,
          width: double.infinity,
          margin: const EdgeInsets.all(15),
          child: CommonWebView(
            url: Urls.chart20Url,
            enableZoom: true,
            onLoadStop: (controller) => updateReadyStatus(webReady: true),
            onWebViewCreated: (controller) {
              webCtrl = controller;
            },
          ),
        ),
      ],
    );
  }
}
