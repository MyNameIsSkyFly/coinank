import 'dart:async';

import 'package:ank_app/entity/event/event_coin_marked.dart';
import 'package:ank_app/entity/event/event_coin_order_changed.dart';
import 'package:ank_app/entity/event/logged_event.dart';
import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/modules/market/contract/contract_coin/widgets/contract_coin_base_logic.dart';
import 'package:ank_app/modules/market/contract/contract_logic.dart';
import 'package:ank_app/modules/market/market_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';

import '../widgets/contract_coin_datagrid_source.dart';

class ContractCoinLogicF extends GetxController
    implements ContractCoinBaseLogic {
  StreamSubscription? _loginSubscription;
  StreamSubscription? _favoriteChangedSubscription;
  StreamSubscription? _orderChangedSubscription;
  final data = RxList<MarkerTickerEntity>();

  Timer? _pollingTimer;
  RxBool isLoading = true.obs;

  final fixedCoin = ['BTC', 'ETH', 'SOL', 'XRP', 'BNB', 'ORDI', 'DOGE', 'ARB'];
  final selectedFixedCoin = RxList<String>(
      ['BTC', 'ETH', 'SOL', 'XRP', 'BNB', 'ORDI', 'DOGE', 'ARB']);

  final fetching = RxBool(false);

  @override
  void onReady() {
    super.onReady();
    if (!StoreLogic.isLogin) {
      onRefresh();
      _startTimer();
    }
  }

  bool firstLoginEvent = true;

  @override
  void onInit() {
    super.onInit();
    _loginSubscription =
        AppConst.eventBus.on<LoginStatusChangeEvent>().listen((event) {
      onRefresh();
      _startTimer();
    });
    _favoriteChangedSubscription =
        AppConst.eventBus.on<EventCoinMarked>().listen((event) {
      if (event.isSpot) return;
      onRefresh();
    });
    _orderChangedSubscription =
        AppConst.eventBus.on<EventCoinOrderChanged>().listen((event) {
      if (event.isSpot || event.isCategory) return;
      dataSource.getColumns(Get.context!);
      dataSource.buildDataGridRows();
    });
    dataSource.getColumns(Get.context!);
    FGBGEvents.stream.listen((event) async {
      if (event == FGBGType.foreground &&
          pageVisible &&
          AppConst.backgroundForAWhile) onRefresh();
    });
  }

  @override
  ContractCoinGridSource dataSource = ContractCoinGridSource([]);

  @override
  void tapItem(MarkerTickerEntity item) {
    AppNav.toCoinDetail(item);
  }

  @override
  Future<void> tapCollect(String? baseCoin) async {
    final item =
        data.firstWhereOrNull((element) => element.baseCoin == baseCoin);
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
    AppConst.eventBus
        .fire(EventCoinMarked(baseCoin: [baseCoin], follow: item?.follow));
    await onRefresh();
  }

  bool isFavorite(String baseCoin) {
    if (!StoreLogic.isLogin) {
      return StoreLogic.to.favoriteContract.contains(baseCoin);
    } else {
      return data.map((element) => element.baseCoin).contains(baseCoin);
    }
  }

  bool _fetching = false;

  @override
  Future<void> onRefresh({bool showLoading = false}) async {
    if (AppConst.networkConnected == false) return;
    if (_fetching) return;
    _fetching = true;
    if (showLoading) Loading.show();
    TickersDataEntity? result;
    if (StoreLogic.isLogin) {
      result = await Apis()
          .postFuturesBigData(
        StoreLogic().contractCoinFilter ?? {},
        page: 1,
        size: 500,
        isFollow: true,
          )
          .whenComplete(() => _fetching = false);
    } else {
      if (StoreLogic.to.favoriteContract.isEmpty) {
        result = TickersDataEntity(list: []);
      } else {
        result = await Apis()
            .postFuturesBigData(
              StoreLogic().contractCoinFilter ?? {},
              page: 1,
              size: 500,
              baseCoins: StoreLogic.to.favoriteContract.join(','),
            )
            .whenComplete(() => _fetching = false);
      }
    }
    _fetching = false;
    Loading.dismiss();
    if (isLoading.value) {
      isLoading.value = false;
    }
    if (!StoreLogic.isLogin) {
      data.assignAll(result?.list?.where((element) =>
              StoreLogic.to.favoriteContract.contains(element.baseCoin)) ??
          []);
    } else {
      data.assignAll(result?.list ?? []);
    }
    dataSource.getColumns(Get.context!);
    dataSource.items.assignAll(result?.list ?? []);
    dataSource.buildDataGridRows();
  }

  @override
  bool get pageVisible {
    if (Get.isBottomSheetOpen == true) return false;
    if (Get.currentRoute != '/') return false;
    if (Get.find<MainLogic>().state.selectedIndex.value != 1) return false;
    if (Get.find<MarketLogic>().tabCtrl.index != 0) return false;
    var index = Get.find<ContractLogic>().state.tabController?.index;
    if (index != 0) return false;
    return true;
  }

  void _startTimer() {
    if (_pollingTimer != null) return;
    _pollingTimer = Timer.periodic(const Duration(seconds: 7), (timer) async {
      if (!AppConst.canRequest) return;
      if (!pageVisible) return;
      await onRefresh();
    });
  }

  Future<void> saveFixedCoin() async {
    if (!StoreLogic.isLogin) {
      for (final item in selectedFixedCoin) {
        await StoreLogic.to.saveFavoriteContract(item);
      }
    } else {
      await Future.wait(
        selectedFixedCoin.map(
          (element) => Apis().getAddFollow(baseCoin: element),
        ),
      );
    }
    AppConst.eventBus.fire(
        EventCoinMarked(baseCoin: selectedFixedCoin.toList(), follow: true));
    onRefresh();
    selectedFixedCoin.clear();
  }


  @override
  void onClose() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _loginSubscription?.cancel();
    _favoriteChangedSubscription?.cancel();
    _orderChangedSubscription?.cancel();
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
