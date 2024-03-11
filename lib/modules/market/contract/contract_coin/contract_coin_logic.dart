import 'dart:async';

import 'package:ank_app/entity/event/logged_event.dart';
import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/modules/market/contract/contract_coin/_f_datagrid_source.dart';
import 'package:ank_app/modules/market/contract/contract_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../market_logic.dart';
import '_datagrid_source.dart';
import 'contract_coin_logic_mixin.dart';
import 'contract_coin_state.dart';

class ContractCoinLogic extends FullLifeCycleController
    with ContractCoinLogicMixin {
  final ContractCoinState state = ContractCoinState();
  StreamSubscription? loginSubscription;

  late final gridSource = GridDataSource([]);
  late final gridSourceF = FGridDataSource([]);

  void sortFavorite({SortType? type}) {
    if (type != null) state.favoriteSortBy = type.name;

    state.favoriteData.sort(
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
        AppUtil.showToast(S.current.removedFromFavorites);
        item.follow = false;
      } else {
        await StoreLogic.to.saveFavoriteContract(item.baseCoin!);
        AppUtil.showToast(S.current.addedToFavorites);
        item.follow = true;
      }
    } else {
      if (item.follow == true) {
        await Apis().getDelFollow(baseCoin: item.baseCoin!);
        AppUtil.showToast(S.current.removedFromFavorites);
        item.follow = false;
      } else {
        await Apis().getAddFollow(baseCoin: item.baseCoin!);
        AppUtil.showToast(S.current.addedToFavorites);
        item.follow = true;
      }
    }
    update(['data']);
    // if (item.follow == false) {
    //   state.favoriteData
    //       .removeWhere((element) => element.baseCoin == item.baseCoin);
    // } else {
    onRefreshF();
    // }
  }

  Future<void> tapCollectF(String? baseCoin) async {
    final item = state.favoriteData
        .firstWhereOrNull((element) => element.baseCoin == baseCoin);
    if (!StoreLogic.isLogin) {
      if (StoreLogic.to.favoriteContract.contains(item?.baseCoin)) {
        await StoreLogic.to.removeFavoriteContract(baseCoin ?? '');
        AppUtil.showToast(S.current.removedFromFavorites);
        item?.follow = false;
      } else {
        await StoreLogic.to.saveFavoriteContract(baseCoin ?? '');
        AppUtil.showToast(S.current.addedToFavorites);
        item?.follow = true;
      }
    } else {
      if (item?.follow == true) {
        await Apis().getDelFollow(baseCoin: item?.baseCoin ?? '');
        AppUtil.showToast(S.current.removedFromFavorites);
        item?.follow = false;
      } else {
        await Apis().getAddFollow(baseCoin: baseCoin ?? '');
        AppUtil.showToast(S.current.addedToFavorites);
        item?.follow = true;
      }
    }
    state.data
        .where((p0) => p0.baseCoin == item?.baseCoin)
        .firstOrNull
        ?.follow = item?.follow;
    await onRefreshF();
  }

  Future<void> onRefresh({bool showLoading = false}) async {
    if (AppConst.networkConnected == false) return;
    if (state.fetching.value) return;
    state.oldData.assignAll(List.from(state.data.toList()));
    if (showLoading) {
      Loading.show();
    }
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
    StoreLogic.to.setContractData(data?.list ?? []);
    gridSource.items.assignAll(data?.list ?? []);
    gridSource.buildDataGridRows();
  }

  bool isFavorite(String baseCoin) {
    if (!StoreLogic.isLogin) {
      return StoreLogic.to.favoriteContract.contains(baseCoin);
    } else {
      return state.favoriteData
          .map((element) => element.baseCoin)
          .contains(baseCoin);
    }
  }

  Future<void> onRefreshF({bool showLoading = false}) async {
    if (AppConst.networkConnected == false) return;
    if (showLoading) {
      Loading.show();
    }
    TickersDataEntity? data;
    if (StoreLogic.isLogin) {
      data = await Apis().getFuturesBigData(
        page: 1,
        size: 500,
        sortBy: state.favoriteSortBy,
        sortType: state.favoriteSortType,
        isFollow: true,
      )
          .catchError((e) {
        return null;
      });
    } else {
      if (StoreLogic.to.favoriteContract.isEmpty) {
        data = TickersDataEntity(list: []);
      } else {
        data = await Apis().getFuturesBigData(
          page: 1,
          size: 500,
          sortBy: state.favoriteSortBy,
          sortType: state.favoriteSortType,
          baseCoins: StoreLogic.to.favoriteContract.join(','),
        );
      }
    }
    Loading.dismiss();
    if (state.isLoadingF.value) {
      state.isLoadingF.value = false;
    }
    if (!StoreLogic.isLogin) {
      state.favoriteData.assignAll(data?.list?.where((element) =>
              StoreLogic.to.favoriteContract.contains(element.baseCoin)) ??
          []);
    } else {
      state.favoriteData.assignAll(data?.list ?? []);
    }
    // sortFavorite();
    gridSourceF.items.assignAll(data?.list ?? []);
    gridSourceF.buildDataGridRows();
  }

  _startTimer() async {
    state.pollingTimer =
        Timer.periodic(const Duration(seconds: 7), (timer) async {
      if (kDebugMode) return;
      if (Get.find<MarketLogic>().tabCtrl.index != 0) return;
      var index = Get.find<ContractLogic>().state.tabController?.index;
      if (Get.find<MainLogic>().state.selectedIndex.value == 1 &&
          Get.currentRoute == '/') {
        if (index == 0) {
          await onRefreshF();
        } else if (index == 1) {
          await onRefresh();
        }
      }
    });
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
    onRefreshF();
    update(['data']);
    state.selectedFixedCoin.clear();
  }

  @override
  void onReady() {
    super.onReady();
    if (!StoreLogic.isLogin) onRefreshF();
  }

  bool firstLoginEvent = true;
  @override
  void onInit() {
    super.onInit();
    _startTimer();
    loginSubscription = AppConst.eventBus.on<LoginStatusChangeEvent>().listen(
      (event) {
        if (!firstLoginEvent) {
          onRefresh();
        }
        firstLoginEvent = false;
        onRefreshF();
      },
    );
    getColumns(Get.context!);
  }

  @override
  void onClose() {
    state.pollingTimer?.cancel();
    state.pollingTimer = null;
    loginSubscription?.cancel();
    super.onClose();
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
