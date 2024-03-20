import 'dart:async';

import 'package:ank_app/entity/event/event_coin_marked.dart';
import 'package:ank_app/entity/event/event_coin_order_changed.dart';
import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/modules/market/market_logic.dart';
import 'package:ank_app/modules/market/spot/widgets/spot_coin_base_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/spot_coin_datagrid_source.dart';

class FSpotCoinLogic extends GetxController implements SpotCoinBaseLogic {
  final data = RxList<MarkerTickerEntity>();
  RxBool isLoading = true.obs;
  late TabController tabCtrl;
  final fixedCoin = [
    //line
    'BTC', 'ETH', 'SOL', 'XRP', 'BNB', 'ORDI', 'DOGE', 'ARB'
  ];
  final selectedFixedCoin = RxList<String>(
      ['BTC', 'ETH', 'SOL', 'XRP', 'BNB', 'ORDI', 'DOGE', 'ARB']);
  final fetching = RxBool(false);
  StreamSubscription? _favoriteChangedSubscription;
  StreamSubscription? _orderChangedSubscription;
  @override
  GridDataSource dataSource = GridDataSource([]);

  @override
  void onInit() {
    dataSource.getColumns(Get.context!);
    onRefresh(showLoading: true);
    _startTimer();
    _favoriteChangedSubscription =
        AppConst.eventBus.on<EventCoinMarked>().listen((event) {
      if (!event.isSpot) return;
      onRefresh();
    });
    _orderChangedSubscription =
        AppConst.eventBus.on<EventCoinOrderChanged>().listen((event) {
      if (!event.isSpot) return;
      dataSource.getColumns(Get.context!);
      dataSource.buildDataGridRows();
    });

    super.onInit();
  }

  @override
  void tapItem(MarkerTickerEntity item) {}

  @override
  Future<void> onRefresh({bool showLoading = false}) async {
    TickersDataEntity? result;
    if (StoreLogic.isLogin) {
      result = await Apis().postSpotAgg(StoreLogic().spotCoinFilter ?? {},
          page: 1,
          size: 500,
          isFollow: true,
          extras: {
            'showToast': false
          }).catchError((e) => TickersDataEntity(list: []));
    } else {
      if (StoreLogic.to.favoriteSpot.isEmpty) {
        result = TickersDataEntity(list: []);
      } else {
        result = await Apis().getSpotAgg(
          page: 1,
          size: 500,
          baseCoins: StoreLogic.to.favoriteSpot.join(','),
        );
      }
    }
    if (isLoading.value) isLoading.value = false;
    data.assignAll(result?.list ?? []);
    dataSource.items.assignAll(result?.list ?? []);
    dataSource.buildDataGridRows();
    dataSource.getColumns(Get.context!);
  }

  Timer? _pollingTimer;

  Future<void> _startTimer() async {
    _pollingTimer = Timer.periodic(const Duration(seconds: 7), (timer) async {
      if (kDebugMode) return;
      if (Get.find<MarketLogic>().tabCtrl.index != 1) return;
      var index = tabCtrl.index;
      if (Get.find<MainLogic>().state.selectedIndex.value == 1 &&
          Get.currentRoute == '/') {
        if (index == 0) {
          await onRefresh();
        }
      }
    });
  }

  @override
  Future<void> tapCollect(String? baseCoin) async {
    final item =
        data.firstWhereOrNull((element) => element.baseCoin == baseCoin);
    if (!StoreLogic.isLogin) {
      if (StoreLogic.to.favoriteSpot.contains(item?.baseCoin)) {
        await StoreLogic.to.removeFavoriteSpot(baseCoin ?? '');
        AppUtil.showToast(S.current.removedFromFavorites);
        item?.follow = false;
      } else {
        await StoreLogic.to.saveFavoriteSpot(baseCoin ?? '');
        AppUtil.showToast(S.current.addedToFavorites);
        item?.follow = true;
      }
    } else {
      if (item?.follow == true) {
        await Apis().postDelFollow(baseCoin: item?.baseCoin ?? '', type: 4);
        AppUtil.showToast(S.current.removedFromFavorites);
        item?.follow = false;
      } else {
        await Apis().postAddFollow(baseCoin: baseCoin ?? '', type: 4);
        AppUtil.showToast(S.current.addedToFavorites);
        item?.follow = true;
      }
    }
    AppConst.eventBus.fire(EventCoinMarked(
        baseCoin: [baseCoin], follow: item?.follow, isSpot: true));
    await onRefresh();
  }

  Future<void> saveFixedCoin() async {
    if (!StoreLogic.isLogin) {
      for (final item in selectedFixedCoin) {
        await StoreLogic.to.saveFavoriteSpot(item);
      }
    } else {
      await Future.wait(
        selectedFixedCoin.map(
          (element) => Apis().postAddFollow(baseCoin: element, type: 4),
        ),
      );
    }
    AppConst.eventBus.fire(EventCoinMarked(
        baseCoin: selectedFixedCoin.toList(), follow: true, isSpot: true));
    onRefresh();
    selectedFixedCoin.clear();
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    _favoriteChangedSubscription?.cancel();
    _orderChangedSubscription?.cancel();
    super.onClose();
  }
}
