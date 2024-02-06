import 'dart:convert';
import 'dart:io';

import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/entity/oi_chart_menu_param_entity.dart';
import 'package:ank_app/modules/coin_detail/coin_detail_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:ank_app/widget/custom_bottom_sheet/custom_bottom_sheet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../coin_detail_contract_logic.dart';

class ChartWeightedFundingView extends StatefulWidget {
  const ChartWeightedFundingView({
    super.key,
    required this.logic,
  });

  final CoinDetailContractLogic logic;

  @override
  State<ChartWeightedFundingView> createState() =>
      _ChartWeightedFundingViewState();
}

class _ChartWeightedFundingViewState extends State<ChartWeightedFundingView> {
  final menuParamEntity = OIChartMenuParamEntity(
    baseCoin: 'BTC',
    exchange: 'ALL',
    interval: '1d',
  ).obs;
  final type = 'fr-oi'.obs;
  String? jsonData;
  ({bool dataReady, bool webReady, String evJS}) readyStatus =
      (dataReady: false, webReady: false, evJS: '');
  InAppWebViewController? webCtrl;

  @override
  void initState() {
    menuParamEntity.value.baseCoin = widget.logic.baseCoin;
    loadOIData();
    super.initState();
  }

  void updateChart() {
    final options = {
      'interval': menuParamEntity.value.interval,
      'baseCoin': menuParamEntity.value.baseCoin,
      'locale': AppUtil.shortLanguageName,
      'theme':
          Theme.of(context).brightness == Brightness.dark ? 'dark' : 'light',
      'frType': 'fr-oi', //fr-oi 持仓加权, fr-vol 成交量加权
    };
    var platformString = Platform.isAndroid ? 'android' : 'ios';
    var jsSource = '''
setChartData($jsonData, "$platformString", "weightFundingRate", ${jsonEncode(options)});    
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

  Future<void> loadOIData() async {
    final result = await Apis().getWeightFundingRate(
      menuParamEntity.value.baseCoin ?? '',
      interval: menuParamEntity.value.interval,
      size: 180,
      endTime: DateTime.now().millisecondsSinceEpoch,
    );
    final json = {'code': '1', 'success': 'true', 'data': result};
    jsonData = jsonEncode(json);
    updateChart();
  }

  final intervalItems = const ['15m', '30m', '1h', '2h', '4h', '12h', '1d'];

  //todo intl
  final typeItems = ['fr-oi', 'fr-vol'];
  final typeMap = {
    'fr-oi': '持仓加权',
    'fr-vol': '成交量加权',
  };

  @override
  Widget build(BuildContext context) {
    return AliveWidget(
      child: OverflowBox(
        minHeight: 515,
        maxHeight: 515,
        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            const Gap(15),
            Obx(() {
              return Row(
                children: [
                  const Gap(15),
                  Expanded(
                    child: Text(
                      '${S.of(context).s_exchange_oi}(${menuParamEntity.value.baseCoin})',
                      style: Styles.tsBody_14m(context),
                    ),
                  ),
                  const Gap(10),
                  _filterChip(context, onTap: () async {
                    final result = await openSelector(intervalItems);
                    if (result != null &&
                        result.toLowerCase() !=
                            menuParamEntity.value.interval?.toLowerCase()) {
                      menuParamEntity.value.interval = result;
                      loadOIData();
                      menuParamEntity.refresh();
                    }
                  }, text: menuParamEntity.value.interval),
                  const Gap(10),
                  _filterChip(context, onTap: () async {
                    final result = await openSelector(typeItems);
                    if (result != null &&
                        result.toLowerCase() != type.toLowerCase()) {
                      type.value = result;
                      loadOIData();
                    }
                  }, text: type.value),
                  const Gap(15),
                ],
              );
            }),
            Container(
              height: 400,
              width: double.infinity,
              margin: const EdgeInsets.all(15),
              child: CommonWebView(
                url: Urls.chart20Url,
                onLoadStop: (controller) => updateReadyStatus(webReady: true),
                onWebViewCreated: (controller) {
                  webCtrl = controller;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(
    BuildContext context, {
    String? text,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          height: 30,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerTheme.color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Text(
                text ?? '',
                style: Styles.tsSub_12m(context),
              ),
              const Gap(10),
              const Icon(Icons.keyboard_arrow_down, size: 14)
            ],
          )),
    );
  }
}
