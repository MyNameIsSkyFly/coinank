import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/entity/short_rate_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/app_refresh.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:ank_app/widget/custom_bottom_sheet/custom_bottom_sheet_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CoinDetailContractLSRatioView extends StatefulWidget {
  const CoinDetailContractLSRatioView({super.key, required this.type});

  final String type;

  @override
  State<CoinDetailContractLSRatioView> createState() =>
      _CoinDetailContractLSRatioViewState();
}

class _CoinDetailContractLSRatioViewState
    extends State<CoinDetailContractLSRatioView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    _getAllData();
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  final RxList<String> _headerTitles = RxList.empty();

  String get _type => widget.type;
  final _longSortTime = '5m'.obs;
  final _webTime = '5m'.obs;
  final RxList<ShortRateEntity> _dataList = RxList.empty();
  Timer? _pollingTimer;
  final _isLoading = true.obs;
  bool _isRefresh = false;
  InAppWebViewController? _webCtrl;
  ShortRateEntity? _jsData;
  ({bool dataReady, bool webReady, String evJS}) _readyStatus =
      (dataReady: false, webReady: false, evJS: '');

  Future<void> _getData(bool isLoading) async {
    if (isLoading) {
      Loading.show();
    }
    final data = await Apis()
        .getShortRateData(interval: _longSortTime.value, baseCoin: _type);
    data
        ?.where((element) => element.exchangeName == 'Okex')
        .forEach((e) => e.exchangeName = 'Okx');
    _dataList.value = data ?? [];
    Loading.dismiss();
  }

  Future<void> _chooseTime(bool isHeader) async {
    final result = await Get.bottomSheet(
      CustomSelector(
        title: S.current.s_choose_time,
        dataList: const ['5m', '15m', '30m', '1h', '2h', '4h', '12h', '1d'],
        current: isHeader ? _longSortTime.value : _webTime.value,
      ),
      isScrollControlled: true,
    );
    if (result != null) {
      final v = result as String;
      if (isHeader) {
        if (_longSortTime.value != v) {
          _longSortTime.value = v;
          await _getData(true);
        }
      } else {
        if (_webTime.value != v) {
          _webTime.value = v;
          await getJSData(true);
          _updateChart();
        }
      }
    }
  }

  Future<void> _getAllData() async {
    await Future.wait<dynamic>([
      _getHeaderData(),
      _getData(false),
      getJSData(false),
    ]).then((value) {
      _isLoading.value = false;
      _updateChart();
    });
  }

  Future<void> _onRefresh(bool isLoading) async {
    if (isLoading) {
      Loading.show();
    }
    _isRefresh = true;
    await Future.wait<dynamic>([
      _getData(false),
      if (isLoading) getJSData(false),
    ]).then((value) {
      Loading.dismiss();
      _isRefresh = false;
      _updateChart();
    });
  }

  Future<void> _getHeaderData() async {
    final data = await Apis().getMarketAllCurrencyData();
    _headerTitles.value = data ?? [];
  }

  Future<void> getJSData(bool isLoading) async {
    if (isLoading) {
      Loading.show();
    }
    final data = await Apis().getShortRateJSData(
        interval: _webTime.value, baseCoin: _type, exchangeName: 'Binance');
    _jsData = data;
    Loading.dismiss();
  }

  void _updateChart() {
    final json = {'code': '1', 'success': true, 'data': _jsData};
    final options = {
      'exchangeName': _jsData?.exchangeName,
      'interval': _webTime.value,
      'baseCoin': _type,
      'locale': AppUtil.shortLanguageName,
      'price': S.current.s_price,
      'seriesLongName': S.current.s_longs,
      'seriesShortName': S.current.s_shorts,
      'ratioName': S.current.s_longshort_ratio,
    };
    final platformString = kIsWeb
        ? 'web'
        : Platform.isAndroid
            ? 'android'
            : 'ios';
    final jsSource = '''
setChartData(${jsonEncode(json)}, "$platformString", "realtimeLongShort", ${jsonEncode(options)});    
    ''';
    _updateReadyStatus(dataReady: true, evJS: jsSource);
  }

  void _updateReadyStatus({bool? dataReady, bool? webReady, String? evJS}) {
    _readyStatus = (
      dataReady: dataReady ?? _readyStatus.dataReady,
      webReady: webReady ?? _readyStatus.webReady,
      evJS: evJS ?? _readyStatus.evJS
    );
    if (_readyStatus.dataReady && _readyStatus.webReady) {
      _webCtrl?.evaluateJavascript(source: _readyStatus.evJS);
    }
  }

  Future<void> _startTimer() async {
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!_isRefresh && AppConst.canRequest && _visible) {
        await _onRefresh(false);
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
  final _key = GlobalKey();
  var _visible = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VisibilityDetector(
      onVisibilityChanged: (info) {
        _visible = info.visibleFraction > 0.01;
      },
      key: _key,
      child: Obx(() {
        return AppRefresh(
          onRefresh: () => _onRefresh(false),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 15),
            physics:
                _isLoading.value ? const NeverScrollableScrollPhysics() : null,
            child: Column(
              children: [
                if (_isLoading.value) const LottieIndicator(),
                if (!_isLoading.value)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${S.current.s_buysel_longshort_ratio}($_type)',
                              style: Styles.tsBody_14m(context),
                            ),
                            InkWell(
                              onTap: () => _chooseTime(true),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    Obx(() {
                                      return Text(
                                        _longSortTime.value,
                                        style: Styles.tsSub_14m(context),
                                      );
                                    }),
                                    const Gap(10),
                                    Image.asset(
                                      Assets.commonIconArrowDown,
                                      width: 10,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 125,
                              child: Text(S.current.s_exchange_name,
                                  style: Styles.tsSub_12(context)),
                            ),
                            Text(S.current.s_longs,
                                style: Styles.tsSub_12(context)),
                            const Spacer(),
                            Text(S.current.s_shorts,
                                style: Styles.tsSub_12(context))
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _dataList.length,
                        itemBuilder: (cnt, idx) {
                          final item = _dataList.toList()[idx];
                          return _DataItem(item: item);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${S.current.s_takerbuy_longshort_ratio_chart}($_type)',
                              style: Styles.tsBody_14m(context),
                            ),
                            InkWell(
                              onTap: () => _chooseTime(false),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    Obx(() {
                                      return Text(
                                        _webTime.value,
                                        style: Styles.tsSub_14m(context),
                                      );
                                    }),
                                    const Gap(10),
                                    Image.asset(
                                      Assets.commonIconArrowDown,
                                      width: 10,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                Container(
                  height: 280,
                  width: double.infinity,
                  margin: const EdgeInsets.all(15),
                  child: CommonWebView(
                    url: Urls.chartUrl,
                    onWebViewCreated: (controller) => _webCtrl = controller,
                    onLoadStop: (controller) =>
                        _updateReadyStatus(webReady: true),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _DataItem extends StatelessWidget {
  const _DataItem({required this.item});

  final ShortRateEntity item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          SizedBox(
            width: 125,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageUtil.exchangeImage(
                    item.exchangeName == 'All'
                        ? 'ALL'
                        : item.exchangeName ?? '',
                    size: 24,
                    isCircle: true),
                const Gap(10),
                Text(item.exchangeName ?? '', style: Styles.tsBody_12m(context))
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: ((item.longRatio ?? 0.5) * 1000).toInt(),
                        child: Container(
                          color: Styles.cUp(context),
                          height: 20,
                        ),
                      ),
                      Flexible(
                        flex: ((item.shortRatio ?? 0.5) * 1000).toInt(),
                        child: Container(
                          color: Styles.cDown(context),
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppUtil.getRate(
                                  rate: item.longRatio ?? 0, precision: 2)
                              .substring(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          AppUtil.getRate(
                                  rate: item.shortRatio ?? 0, precision: 2)
                              .substring(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
