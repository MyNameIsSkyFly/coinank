import 'dart:convert';
import 'dart:io';

import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/modules/market/contract/contract_coin/contract_coin_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class CategoryContractCharts extends StatelessWidget {
  const CategoryContractCharts({
    super.key,
    this.tag,
  });

  final String? tag;

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(height: 10),
          _HeatMapView(),
          SizedBox(height: 10),
          _BarChartView(),
        ],
      ),
    );
  }
}

class _HeatMapView extends StatefulWidget {
  const _HeatMapView();

  @override
  State<_HeatMapView> createState() => _HeatMapViewState();
}

class _HeatMapViewState extends State<_HeatMapView> {
  final isOi = false.obs;
  InAppWebViewController? webCtrl;
  final logic = Get.find<ContractCoinLogic>(tag: 'category');

  @override
  void initState() {
    logic.tag.listen((p0) => _evaluate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Text(S.of(context).heat_map, style: Styles.tsBody_14m(context)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerTheme.color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx(() {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          isOi.value = false;
                          _evaluate();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: isOi.value
                                ? Colors.transparent
                                : Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            S.of(context).s_24h_turnover,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: Styles.fontMedium,
                                color: isOi.value
                                    ? Styles.cSub(context)
                                    : Styles.cBody(context)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          isOi.value = true;
                          _evaluate();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: isOi.value
                                ? Theme.of(context).scaffoldBackgroundColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(S.of(context).s_oi,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: Styles.fontMedium,
                                  color: isOi.value
                                      ? Styles.cBody(context)
                                      : Styles.cSub(context))),
                        ),
                      ),
                    ],
                  );
                }),
              )
            ],
          ),
        ),
        SizedBox(
          height: 377,
          width: double.infinity,
          child: CommonWebView(
            onWebViewCreated: (controller) => webCtrl = controller,
            enableZoom: true,
            onLoadStop: (controller) async => _evaluate(),
            url: Urls.categoryHeatMapUrl,
          ),
        ),
      ],
    );
  }

  void _evaluate() {
    final dataParams = {
      'productType': 'SWAP',
      'category': logic.tag.value,
      'type': isOi.value ? 'openInterest' : 'turnover24h'
      // vol: 成交量, oi: 持仓
    };
    var platformString = Platform.isAndroid ? 'android' : 'ios';
    var dataParamsString = jsonEncode(dataParams);
    var localeString = jsonEncode(
        {'locale': AppUtil.shortLanguageName, 'light': !Get.isDarkMode});
    var jsSource =
        '''setChartData($dataParamsString, "$platformString", "categoryHeatMap", $localeString);''';
    webCtrl?.evaluateJavascript(source: jsSource);
  }
}

class _BarChartView extends StatefulWidget {
  const _BarChartView();

  @override
  State<_BarChartView> createState() => _BarChartViewState();
}

class _BarChartViewState extends State<_BarChartView> {
  final selectedIndex = 0.obs;
  InAppWebViewController? webCtrl;
  final logic = Get.find<ContractCoinLogic>(tag: 'category');

  @override
  void initState() {
    logic.tag.listen((p0) => _evaluate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Text(S.of(context).heat_map, style: Styles.tsBody_14m(context)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerTheme.color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx(() {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          selectedIndex.value = 0;
                          _evaluate();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: selectedIndex.value == 0
                                ? Theme.of(context).scaffoldBackgroundColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            S.of(context).s_24h_turnover,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: Styles.fontMedium,
                                color: selectedIndex.value == 0
                                    ? Styles.cSub(context)
                                    : Styles.cBody(context)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          selectedIndex.value = 1;
                          _evaluate();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: selectedIndex.value == 1
                                ? Theme.of(context).scaffoldBackgroundColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(S.of(context).s_oi,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: Styles.fontMedium,
                                  color: selectedIndex.value == 1
                                      ? Styles.cBody(context)
                                      : Styles.cSub(context))),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          selectedIndex.value = 2;
                          _evaluate();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: selectedIndex.value == 2
                                ? Theme.of(context).scaffoldBackgroundColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(S.of(context).s_funding_rate,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: Styles.fontMedium,
                                  color: selectedIndex.value == 2
                                      ? Styles.cBody(context)
                                      : Styles.cSub(context))),
                        ),
                      )
                    ],
                  );
                }),
              )
            ],
          ),
        ),
        SizedBox(
          height: 377,
          width: double.infinity,
          child: CommonWebView(
            onWebViewCreated: (controller) => webCtrl = controller,
            enableZoom: true,
            onLoadStop: (controller) async => _evaluate(),
            url: Urls.categoryChartUrl,
          ),
        ),
      ],
    );
  }

  void _evaluate() {
    // setChartData(
    //     {
    //         productType:"spot",  // spot 现货, swap 合约
    //         category:"layer-1", // 分类
    //         type:"turnover24h", //数据类型: turnover24h: 24小时成交额, openInterest: 持仓, fundingRate: 资金费率 , marketCap: 市值
    //     },
    //     "android",
    //     "categoryHeatMap",
    //     {
    //         theme: "light",
    //         locale:"zh"
    //     }
    // )
    final dataParams = {
      'productType': 'SWAP',
      'category': logic.tag.value,
      'type': selectedIndex.value == 0
          ? 'turnover24h'
          : selectedIndex.value == 1
              ? 'openInterest'
              : 'fundingRate'
      // vol: 成交量, oi: 持仓
    };
    var platformString = Platform.isAndroid ? 'android' : 'ios';
    var dataParamsString = jsonEncode(dataParams);
    var localeString = jsonEncode(
        {'locale': AppUtil.shortLanguageName, 'light': !Get.isDarkMode});
    var jsSource =
        '''setChartData($dataParamsString, "$platformString", "categoryHeatMap", $localeString);''';
    webCtrl?.evaluateJavascript(source: jsSource);
  }
}
