import 'dart:async';

import 'package:ank_app/entity/btc_reduce_entity.dart';
import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/entity/head_statistics_entity.dart';
import 'package:ank_app/entity/home_fund_rate_entity.dart';
import 'package:ank_app/modules/market/contract/contract_logic.dart';
import 'package:ank_app/modules/market/market_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../entity/news_entity.dart';
import '../main/main_logic.dart';

class HomeLogic extends GetxController {
  final mainLogic = Get.find<MainLogic>();
  final priceChangeData = Rxn<TickersDataEntity>();
  final oiChangeData = Rxn<TickersDataEntity>();
  final homeInfoData = Rxn<HomeInfoEntity>();
  final fundRateList = RxList<HomeFundRateEntity>();
  final btcReduceData = Rxn<BtcReduceEntity>();
  final newsList = RxList<NewsEntity>();
  late TabController tabCtrl;

  Timer? _pollingTimer;
  Timer? btcReduceTimer;
  bool isRefreshing = false;

  List<MarkerTickerEntity>? get priceList => priceChangeData.value?.list;

  List<MarkerTickerEntity>? get oiList => oiChangeData.value?.list;

  String get buySellLongShortRatio =>
      ((double.tryParse(homeInfoData.value?.longRatio ?? '') ?? 0) /
              (double.tryParse(homeInfoData.value?.shortRatio ?? '1') ?? 1))
          .toStringAsFixed(2);
  bool hideBtcReduce = DateTime.now().isAfter(DateTime(2024, 4, 21));

  @override
  void onReady() {
    onRefresh();
    startTimer();
  }

  void startTimer() {
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        if (!AppConst.canRequest ||
            tabCtrl.index != 0 ||
            mainLogic.selectedIndex.value != 0 ||
            isRefreshing ||
            Get.currentRoute != RouteConfig.main) return;
        onRefresh();
      },
    );
  }

  void stopTimer() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> onRefresh() async {
    if (AppConst.networkConnected == false) return;
    isRefreshing = true;
    await Future.wait([
      loadPriceChgData(),
      loadOIChgData(),
      loadHomeData(),
      loadFundRateData(),
      loadBtcReduce(),
      loadNews(),
    ]).whenComplete(() {
      isRefreshing = false;
    });
  }

  Future<void> loadPriceChgData() async {
    final data = await Apis().postFuturesBigData(
      {'openInterest': '5000000~'},
      page: 1,
      size: 3,
      sortBy: 'priceChangeH24',
      sortType: 'descend',
    );
    priceChangeData.value = data;
  }

  Future<void> loadOIChgData() async {
    final data = await Apis()
        .getFuturesBigData(page: 1, size: 3, sortBy: '', sortType: '');
    oiChangeData.value = data;
  }

  Future<void> loadHomeData() async {
    final data = await Apis().getHeadStatistics();
    homeInfoData.value = data;
  }

  Future<void> loadFundRateData() async {
    final data = await Apis().getHomeFundRateData();
    fundRateList.assignAll(data ?? []);
  }

  Future<void> loadBtcReduce() async {
    if (hideBtcReduce) return;
    final data = await Apis().getBtcReduce();
    btcReduceData.value = data;
    btcReduceTimer ??= Timer.periodic(const Duration(minutes: 1), (timer) {
      btcReduceData.refresh();
    });
  }

  Future<void> loadNews() async {
    final data = await Apis().getNewsList(
      page: 1,
      pageSize: 5,
      type: 2,
      isPopular: true,
      lang: AppUtil.shortLanguageName,
    );
    newsList.assignAll(data ?? []);
  }

  @override
  void onClose() {
    btcReduceTimer?.cancel();
    _pollingTimer?.cancel();
    btcReduceTimer = null;
    super.onClose();
  }

  void toMarketModule(int index) {
    Get.find<MainLogic>().selectTab(1);
    Get.find<MarketLogic>().tabCtrl.animateTo(0);
    Get.find<ContractLogic>().selectIndex(index);
  }
}
