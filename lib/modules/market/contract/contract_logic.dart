import 'dart:async';
import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/modules/market/market_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contract_state.dart';

class ContractLogic extends FullLifeCycleController with FullLifeCycleMixin {
  final ContractState state = ContractState();

  void tapSort(SortType type) {
    switch (type) {
      case SortType.openInterest:
        state.oiSort =
            state.oiSort == SortStatus.down ? SortStatus.up : SortStatus.down;
        state.oiChangeSort = SortStatus.normal;
        state.priceSort = SortStatus.normal;
        state.priceChangSort = SortStatus.normal;
      case SortType.openInterestCh24:
        state.oiChangeSort = state.oiChangeSort == SortStatus.down
            ? SortStatus.up
            : SortStatus.down;
        state.oiSort = SortStatus.normal;
        state.priceSort = SortStatus.normal;
        state.priceChangSort = SortStatus.normal;
      case SortType.price:
        state.priceSort = state.priceSort == SortStatus.down
            ? SortStatus.up
            : SortStatus.down;
        state.oiSort = SortStatus.normal;
        state.oiChangeSort = SortStatus.normal;
        state.priceChangSort = SortStatus.normal;
      case SortType.priceChangeH24:
        state.priceChangSort = state.priceChangSort == SortStatus.down
            ? SortStatus.up
            : SortStatus.down;
        state.oiSort = SortStatus.normal;
        state.oiChangeSort = SortStatus.normal;
        state.priceSort = SortStatus.normal;
      case SortType.liquidationH24:
        break;
    }
    update(['sort']);
    startTimer();
  }

  void tapItem(MarkerTickerEntity item) {
    /// TODO 跳转订单流 并传参 item.symbol item.exchangeName
  }

  void tapCollect(MarkerTickerEntity item) {
    /// TODO 收藏需登录
  }

  Future<void> onRefresh() async {
    state.isRefresh = true;
    final data = await Apis().getFuturesBigData(
      page: 1,
      size: 500,
      sortBy: state.sortBy,
      sortType: state.sortType,
    );
    state.data = data;
    update(['data']);
    state.isRefresh = false;
  }

  startTimer() async {
    cancelTimer();
    await onRefresh();
    state.pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      timer.cancel();
      if (Get.find<MainLogic>().state.selectedIndex.value == 1 &&
          !state.isRefresh &&
          Get.find<MarketLogic>().state.tabController?.index == 0 &&
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

enum SortType {
  openInterestCh24, //持仓变化
  openInterest, // 持仓
  price, // 价格
  priceChangeH24, // 价格变化
  liquidationH24, // 爆仓变化
}
