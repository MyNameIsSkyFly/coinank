import 'dart:async';

import 'package:ank_app/entity/event/logged_event.dart';
import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/modules/market/market_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contract_state.dart';

class ContractLogic extends FullLifeCycleController with FullLifeCycleMixin {
  final ContractState state = ContractState();
  StreamSubscription? loginSubscription;

  void sortFavorite({SortType? type}) {
    if (type != null) state.favoriteSortBy = type.name;
    final list = <MarkerTickerEntity>[];
    for (var element in state.data) {
      if (element.follow == true) {
        list.add(element);
      }
    }
    list.sort(
      (a, b) {
        if (state.favoriteSortBy == 'openInterestCh24') {
          if (state.favoriteOiChangeSort.value == SortStatus.normal) {
            return (b.openInterest ?? 0).compareTo((a.openInterest ?? 0));
          }
          var result =
              (b.openInterestCh24 ?? 0).compareTo((a.openInterestCh24 ?? 0));
          return state.favoriteOiChangeSort.value != SortStatus.down
              ? -result
              : result;
        } else if (state.favoriteSortBy == 'price') {
          if (state.favoritePriceSort.value == SortStatus.normal) {
            return (b.openInterest ?? 0).compareTo((a.openInterest ?? 0));
          }
          var result = (b.price ?? 0).compareTo((a.price ?? 0));
          return state.favoritePriceSort.value != SortStatus.down
              ? -result
              : result;
        } else if (state.favoriteSortBy == 'priceChangeH24') {
          if (state.favoritePriceChangeSort.value == SortStatus.normal) {
            return (b.openInterest ?? 0).compareTo((a.openInterest ?? 0));
          }
          var result =
              (b.priceChangeH24 ?? 0).compareTo((a.priceChangeH24 ?? 0));
          return state.favoritePriceChangeSort.value != SortStatus.down
              ? -result
              : result;
        }
        var result = (b.openInterest ?? 0).compareTo((a.openInterest ?? 0));
        return state.favoriteOiSort.value != SortStatus.down ? -result : result;
      },
    );
    state.favoriteData.assignAll(list);
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
        state.oiChangeSort = state.oiChangeSort == SortStatus.normal
            ? SortStatus.down
            : state.oiChangeSort == SortStatus.down
                ? SortStatus.up
                : SortStatus.normal;
        state.oiSort = SortStatus.normal;
        state.priceSort = SortStatus.normal;
        state.priceChangSort = SortStatus.normal;
        sortBy = 'openInterestCh24';
        sortType = state.oiChangeSort == SortStatus.down ? 'descend' : 'ascend';
        if (state.oiChangeSort == SortStatus.normal) {
          sortBy = 'openInterest';
          sortType = 'descend';
          state.oiSort = SortStatus.down;
        }
      case SortType.price:
        state.priceSort = state.priceSort == SortStatus.normal
            ? SortStatus.down
            : state.priceSort == SortStatus.down
                ? SortStatus.up
                : SortStatus.normal;
        state.oiSort = SortStatus.normal;
        state.oiChangeSort = SortStatus.normal;
        state.priceChangSort = SortStatus.normal;
        sortBy = 'price';
        sortType = state.priceSort == SortStatus.down ? 'descend' : 'ascend';
        if (state.priceSort == SortStatus.normal) {
          sortBy = 'openInterest';
          sortType = 'descend';
          state.oiSort = SortStatus.down;
        }
      case SortType.priceChangeH24:
        state.priceChangSort = state.priceChangSort == SortStatus.normal
            ? SortStatus.down
            : state.priceChangSort == SortStatus.down
                ? SortStatus.up
                : SortStatus.normal;
        state.oiSort = SortStatus.normal;
        state.oiChangeSort = SortStatus.normal;
        state.priceSort = SortStatus.normal;
        sortBy = 'priceChangeH24';
        sortType =
            state.priceChangSort == SortStatus.down ? 'descend' : 'ascend';
        if (state.priceChangSort == SortStatus.normal) {
          sortBy = 'openInterest';
          sortType = 'descend';
          state.oiSort = SortStatus.down;
        }
      default:
        break;
    }
    update(['sort']);
    if (state.sortBy == sortBy && state.sortType == sortType) return;
    state.sortType = sortType;
    state.sortBy = sortBy;
    await onRefresh(showLoading: true);
  }

  void tapItem(MarkerTickerEntity item) {
    AppNav.toCoinDetail(item);
    // AppUtil.toKLine(item.exchangeName ?? '', item.symbol ?? '',
    //     item.baseCoin ?? '', 'SWAP');
  }

  Future<void> tapCollect(MarkerTickerEntity item) async {
    if (!StoreLogic.isLogin) {
      if (item.follow == true) {
        await StoreLogic.to.removeFavoriteContract(item.baseCoin!);
        item.follow = false;
      } else {
        await StoreLogic.to.saveFavoriteContract(item.baseCoin!);
        item.follow = true;
      }
    } else {
      if (item.follow == true) {
        await Apis().getDelFollow(baseCoin: item.baseCoin!);
        item.follow = false;
      } else {
        await Apis().getAddFollow(baseCoin: item.baseCoin!);
        item.follow = true;
      }
    }
    update(['data']);
    sortFavorite();
  }

  Future<void> tapFavoriteCollect(String? baseCoin) async {
    final item =
        state.data.firstWhereOrNull((element) => element.baseCoin == baseCoin);
    if (item == null) return;
    if (!StoreLogic.isLogin) {
      if (item.follow == true) {
        await StoreLogic.to.removeFavoriteContract(item.baseCoin!);
        item.follow = false;
      } else {
        await StoreLogic.to.saveFavoriteContract(item.baseCoin!);
        item.follow = true;
      }
    } else {
      if (item.follow == true) {
        await Apis().getDelFollow(baseCoin: item.baseCoin!);
        item.follow = false;
      } else {
        await Apis().getAddFollow(baseCoin: item.baseCoin!);
        item.follow = true;
      }
    }
    state.data.refresh();
    update(['data']);
    sortFavorite();
  }

  Future<void> onRefresh({bool showLoading = false}) async {
    if (AppConst.networkConnected == false) return;
    if (state.fetching.value) return;
    state.oldData.assignAll(List.from(state.data.toList()));
    if (showLoading) {
      Loading.show();
    }
    state.isRefresh = true;
    state.fetching.value = true;
    final data = await Apis().getFuturesBigData(
      page: 1,
      size: 500,
      sortBy: state.sortBy,
      sortType: state.sortType,
    );
    state.fetching.value = false;
    Loading.dismiss();
    if (state.isLoading.value) {
      state.isLoading.value = false;
    }
    if (!StoreLogic.isLogin) {
      final favorites = StoreLogic.to.favoriteContract;
      for (final item in data?.list ?? <MarkerTickerEntity>[]) {
        item.follow = favorites.contains(item.baseCoin);
      }
    }
    state.data.assignAll(data?.list ?? []);
    update(['data']);
    sortFavorite();
    state.isRefresh = false;
    StoreLogic.to.setContractData(data?.list ?? []);
  }

  _startTimer() async {
    state.pollingTimer =
        Timer.periodic(const Duration(seconds: 7), (timer) async {
      var index2 = Get.find<MarketLogic>().state.tabController?.index;
      if (Get.find<MainLogic>().state.selectedIndex.value == 1 &&
          !state.isRefresh &&
          (index2 == 0 || index2 == 1) &&
          state.appVisible &&
          Get.currentRoute == '/') {
        await onRefresh();
      }
    });
  }

  _scrollListener() {
    double offset = state.scrollController.offset;
    state.isScrollDown.value = offset <= 0 || state.offset - offset > 0;
    state.offset = offset;
  }

  _scrollFListener() {
    final maxScrollExtent = state.scrollControllerF.position.maxScrollExtent;
    final isOverScrolled = state.scrollControllerF.offset > maxScrollExtent;
    if (isOverScrolled) {
      state.isScrollDownF.value = false;
      return;
    }

    double offset = state.scrollControllerF.offset;
    state.isScrollDownF.value = offset <= 0 || state.offset - offset > 0;
    state.offset = offset;
  }

  Future<void> saveFixedCoin() async {
    if (!StoreLogic.isLogin) {
      for (final item in state.selectedFixedCoin) {
        await StoreLogic.to.saveFavoriteContract(item);
      }
    } else {
      await Future.wait(
        state.selectedFixedCoin.map(
          (element) => Apis().getAddFollow(baseCoin: element),
        ),
      );
    }
    for (var element in state.data) {
      if (state.selectedFixedCoin.contains(element.baseCoin)) {
        element.follow = true;
      }
    }
    sortFavorite();
    update(['data']);
    state.selectedFixedCoin.clear();
  }

  @override
  void onReady() {
    super.onReady();
    if (!StoreLogic.isLogin) onRefresh();
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
    state.scrollController.addListener(_scrollListener);
    state.scrollControllerF.addListener(_scrollFListener);
    if (StoreLogic.isLogin) {
      loginSubscription = AppConst.eventBus.on<LoginStatusChangeEvent>().listen(
            (event) => onRefresh(),
          );
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    state.scrollController.removeListener(_scrollListener);
    state.scrollControllerF.removeListener(_scrollFListener);
    state.pollingTimer?.cancel();
    state.pollingTimer = null;
    loginSubscription?.cancel();
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
