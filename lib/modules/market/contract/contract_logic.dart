import 'dart:async';
import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/modules/market/market_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/route/app_nav.dart';
import 'package:ank_app/util/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contract_state.dart';

class ContractLogic extends FullLifeCycleController with FullLifeCycleMixin {
  final ContractState state = ContractState();

  void tapAllCollect() {
    state.isCollect = !state.isCollect;
    update(['collect']);
    sortCollect();
  }

  sortCollect() {
    if (state.isCollect) {
      state.data = List<MarkerTickerEntity>.from(state.originalData ?? [])
          .where((element) => element.follow == true)
          .toList();
    } else {
      state.data = List.from(state.originalData ?? []);
    }

    update(['data']);
  }

  Future<void> tapSort(SortType type) async {
    String sortBy = '';
    String sortType = '';
    switch (type) {
      case SortType.openInterest:
        state.oiSort =
            state.oiSort == SortStatus.down ? SortStatus.up : SortStatus.down;
        state.oiChangeSort = SortStatus.normal;
        state.priceSort = SortStatus.normal;
        state.priceChangSort = SortStatus.normal;
        sortBy = 'openInterest';
        sortType = state.oiSort == SortStatus.down ? 'descend' : 'ascend';
      case SortType.openInterestCh24:
        state.oiChangeSort = state.oiChangeSort == SortStatus.down
            ? SortStatus.up
            : SortStatus.down;
        state.oiSort = SortStatus.normal;
        state.priceSort = SortStatus.normal;
        state.priceChangSort = SortStatus.normal;
        sortBy = 'openInterestCh24';
        sortType = state.oiChangeSort == SortStatus.down ? 'descend' : 'ascend';
      case SortType.price:
        state.priceSort = state.priceSort == SortStatus.down
            ? SortStatus.up
            : SortStatus.down;
        state.oiSort = SortStatus.normal;
        state.oiChangeSort = SortStatus.normal;
        state.priceChangSort = SortStatus.normal;
        sortBy = 'price';
        sortType = state.priceSort == SortStatus.down ? 'descend' : 'ascend';
      case SortType.priceChangeH24:
        state.priceChangSort = state.priceChangSort == SortStatus.down
            ? SortStatus.up
            : SortStatus.down;
        state.oiSort = SortStatus.normal;
        state.oiChangeSort = SortStatus.normal;
        state.priceSort = SortStatus.normal;
        sortBy = 'priceChangeH24';
        sortType =
            state.priceChangSort == SortStatus.down ? 'descend' : 'ascend';
      default:
        break;
    }
    update(['sort']);
    if (state.sortBy == sortBy && state.sortType == sortType) return;
    state.sortType = sortType;
    state.sortBy = sortBy;
    await onRefresh();
  }

  void tapItem(MarkerTickerEntity item) {
    AppUtil.toKLine(item.exchangeName ?? '', item.symbol ?? '',
        item.baseCoin ?? '', 'SWAP');
  }

  tapCollect(MarkerTickerEntity item) async {
    if (!StoreLogic.isLogin) {
      AppNav.toLogin();
    } else {
      if (item.follow == true) {
        final data = await Apis().getDelFollow(baseCoin: item.baseCoin!);
        item.follow = false;
      } else {
        final data = await Apis().getAddFollow(baseCoin: item.baseCoin!);
        item.follow = true;
      }
      sortCollect();
    }
  }

  Future<void> onRefresh() async {
    state.isRefresh = true;
    final data = await Apis().getFuturesBigData(
      page: 1,
      size: 500,
      sortBy: state.sortBy,
      sortType: state.sortType,
    );
    state.originalData = data?.list;
    sortCollect();
    state.isRefresh = false;
    StoreLogic.to.setContractData(data?.list ?? []);
  }

  _startTimer() async {
    state.pollingTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (Get.find<MainLogic>().state.selectedIndex.value == 1 &&
          !state.isRefresh &&
          Get.find<MarketLogic>().state.tabController?.index == 0 &&
          state.appVisible) {
        await onRefresh();
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    state.pollingTimer?.cancel();
    state.pollingTimer = null;
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
  }

  @override
  void onResumed() {
    //应用程序可见，前台
    state.appVisible = true;
  }
}

enum SortType {
  openInterestCh24, //持仓变化
  openInterest, // 持仓
  price, // 价格
  priceChangeH24, // 价格变化
  liquidationH24, // 爆仓变化
  volH24, //24小时成交额
  fundingRate, //资金费率
}
