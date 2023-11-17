import 'dart:async';

import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/modules/market/contract/contract_logic.dart';
import 'package:ank_app/modules/market/market_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contract_market_state.dart';

class ContractMarketLogic extends FullLifeCycleController
    with FullLifeCycleMixin {
  final ContractMarketState state = ContractMarketState();

  tapHeader(String type) async {
    if (type == state.type) return;
    state.type = type;
    update(['header']);
    await startTimer();
  }

  toSearch() async {
    final result = await Get.toNamed(RouteConfig.contractMarketSearch,
        arguments: state.headerTitles);
    if (result != null) {
      String type = result as String;
      state.type = type;
      update(['header']);
      state.itemScrollController.scrollTo(
        index: state.headerTitles!.indexOf(type),
        alignment: 0.5,
        duration: const Duration(milliseconds: 500),
      );
      startTimer();

    }
  }

  void tapSort(SortType type) {
    String sortBy = '';
    String sortType = '';
    switch (type) {
      case SortType.price:
        state.priceSort = state.priceSort == SortStatus.down
            ? SortStatus.up
            : SortStatus.down;
        state.volSort = SortStatus.normal;
        state.oiSort = SortStatus.normal;
        state.rateSort = SortStatus.normal;
        sortBy = 'lastPrice';
        sortType = state.priceSort == SortStatus.down ? 'descend' : 'ascend';
      case SortType.volH24:
        state.volSort =
            state.volSort == SortStatus.down ? SortStatus.up : SortStatus.down;
        state.priceSort = SortStatus.normal;
        state.oiSort = SortStatus.normal;
        state.rateSort = SortStatus.normal;
        sortBy = 'turnover24h';
        sortType = state.volSort == SortStatus.down ? 'descend' : 'ascend';
      case SortType.openInterest:
        state.oiSort =
            state.oiSort == SortStatus.down ? SortStatus.up : SortStatus.down;
        state.volSort = SortStatus.normal;
        state.priceSort = SortStatus.normal;
        state.rateSort = SortStatus.normal;
        sortBy = 'oiUSD';
        sortType = state.oiSort == SortStatus.down ? 'descend' : 'ascend';
      case SortType.fundingRate:
        state.rateSort =
            state.rateSort == SortStatus.down ? SortStatus.up : SortStatus.down;
        state.volSort = SortStatus.normal;
        state.oiSort = SortStatus.normal;
        state.priceSort = SortStatus.normal;
        sortBy = 'fundingRate';
        sortType = state.rateSort == SortStatus.down ? 'descend' : 'ascend';
      default:
        break;
    }
    update(['sort']);
    if (state.sortBy == sortBy && state.sortType == sortType) return;
    state.sortType = sortType;
    state.sortBy = sortBy;
    startTimer();
  }

  Future<void> getAllData() async {
    await Future.wait([getHeaderData(), startTimer()]).then((value) {
      update();
    });
  }

  Future<void> getHeaderData() async {
    final data = await Apis().getMarketAllCurrencyData();
    state.headerTitles = data;
  }

  Future<void> getContentData() async {
    state.isRefresh = true;
    final data = await Apis().getContractMarketData(
        baseCoin: state.type, sortType: state.sortType, sortBy: state.sortBy);
    state.dataList = data;
    state.isRefresh = false;
  }

  Future<void> onRefresh() async {
    await getContentData();
    update(['content']);
  }

  Future<void> startTimer() async {
    cancelTimer();
    await onRefresh();
    state.pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      timer.cancel();
      if (Get.find<MainLogic>().state.selectedIndex.value == 1 &&
          !state.isRefresh &&
          Get.find<MarketLogic>().state.tabController?.index == 1 &&
          state.appVisible) {
        startTimer();
      }
    });
  }

  cancelTimer() {
    state.pollingTimer?.cancel();
    state.pollingTimer = null;
  }

  @override
  void onReady() {
    super.onReady();
    getAllData();
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    cancelTimer();
    super.onClose();
  }

  @override
  void onDetached() {}

  @override
  void onHidden() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {
    //应用程序不可见，后台
    state.appVisible = false;
    cancelTimer();
  }

  @override
  void onResumed() {
    //应用程序可见，前台
    state.appVisible = true;
    if (!state.appVisible) {
      startTimer();
    }
  }
}
