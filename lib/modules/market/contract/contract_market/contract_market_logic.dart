import 'dart:async';

import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/modules/market/contract/contract_coin/contract_coin_logic.dart';
import 'package:ank_app/modules/market/contract/contract_logic.dart';
import 'package:ank_app/modules/market/market_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/foundation.dart';
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
    state.oldDataList = null;
    await onRefresh(true);
  }

  toSearch() async {
    final result = await Get.toNamed(RouteConfig.contractMarketSearch,
        arguments: state.headerTitles);
    if (result != null) {
      String type = result as String;
      if (state.type != type) {
        state.type = type;
        update(['header']);
        state.itemScrollController.scrollTo(
          index: state.headerTitles!.indexOf(type),
          alignment: 0.5,
          duration: const Duration(milliseconds: 200),
        );
        state.oldDataList = null;
        await onRefresh(true);
      }
    }
  }

  void tapSort(SortType type) {
    String? sortBy;
    String sortType = '';
    switch (type) {
      case SortType.price:
        state.priceSort = state.priceSort == SortStatus.normal
            ? SortStatus.down
            : state.priceSort == SortStatus.down
                ? SortStatus.up
                : SortStatus.normal;
        state.volSort = SortStatus.normal;
        state.oiSort = SortStatus.normal;
        state.rateSort = SortStatus.normal;
        sortBy = state.priceSort == SortStatus.normal ? null : 'lastPrice';
        sortType = state.priceSort == SortStatus.up ? 'ascend' : 'descend';
      case SortType.volH24:
        state.volSort = state.volSort == SortStatus.normal
            ? SortStatus.down
            : state.volSort == SortStatus.down
                ? SortStatus.up
                : SortStatus.normal;
        state.priceSort = SortStatus.normal;
        state.oiSort = SortStatus.normal;
        state.rateSort = SortStatus.normal;
        sortBy = state.volSort == SortStatus.normal ? null : 'turnover24h';
        sortType = state.volSort == SortStatus.up ? 'ascend' : 'descend';
      case SortType.openInterest:
        state.oiSort = state.oiSort == SortStatus.normal
            ? SortStatus.down
            : state.oiSort == SortStatus.down
                ? SortStatus.up
                : SortStatus.normal;
        state.volSort = SortStatus.normal;
        state.priceSort = SortStatus.normal;
        state.rateSort = SortStatus.normal;
        sortBy = state.oiSort == SortStatus.normal ? null : 'oiUSD';
        sortType = state.oiSort == SortStatus.up ? 'ascend' : 'descend';
      case SortType.fundingRate:
        state.rateSort = state.rateSort == SortStatus.normal
            ? SortStatus.down
            : state.rateSort == SortStatus.down
                ? SortStatus.up
                : SortStatus.normal;
        state.volSort = SortStatus.normal;
        state.oiSort = SortStatus.normal;
        state.priceSort = SortStatus.normal;
        sortBy = state.rateSort == SortStatus.normal ? null : 'fundingRate';
        sortType = state.rateSort == SortStatus.up ? 'ascend' : 'descend';
      default:
        break;
    }
    update(['sort']);
    if (state.sortBy == sortBy && state.sortType == sortType) return;
    state.sortType = sortType;
    state.sortBy = sortBy;
    onRefresh(true);
  }

  Future<void> getAllData() async {
    if (state.isLoading.value) {
      await Future.wait([getHeaderData(), _getContentData()]).then((value) {
        state.isLoading.value = false;
      });
    } else {
      await onRefresh(false);
    }
  }

  Future<void> getHeaderData() async {
    final data = await Apis().getMarketAllCurrencyData();
    state.headerTitles = data;
  }

  Future<void> _getContentData() async {
    state.isRefresh = true;
    final data = await Apis().getContractMarketData(
        baseCoin: state.type, sortType: state.sortType, sortBy: state.sortBy);
    state.dataList = data;
    state.isRefresh = false;
  }

  Future<void> onRefresh(bool showLoading) async {
    state.oldDataList = List.from(state.dataList ?? []);
    if (showLoading) {
      Loading.show();
    }
    await _getContentData();
    Loading.dismiss();
    update(['content']);
  }

  Future<void> _startTimer() async {
    state.pollingTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (kDebugMode) return;
      if (Get.find<MarketLogic>().tabCtrl.index != 0) return;
      if (Get.find<MainLogic>().state.selectedIndex.value == 1 &&
          !state.isRefresh &&
          Get.find<ContractLogic>().state.tabController?.index == 3 &&
          state.appVisible) {
        await onRefresh(false);
      }
    });
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
