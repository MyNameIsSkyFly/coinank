import 'dart:async';

import 'package:ank_app/entity/event/event_coin_marked.dart';
import 'package:ank_app/entity/event/event_coin_order_changed.dart';
import 'package:ank_app/entity/event/logged_event.dart';
import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/modules/market/market_logic.dart';
import 'package:ank_app/modules/market/spot/widgets/spot_coin_base_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';

import '../spot_logic.dart';
import '../widgets/spot_coin_datagrid_source.dart';

class SpotCoinLogicF extends GetxController implements SpotCoinBaseLogic {
  final data = RxList<MarkerTickerEntity>();
  RxBool isLoading = true.obs;

  // late TabController tabCtrl;
  final fixedCoin = [
    //line
    'BTC', 'ETH', 'SOL', 'XRP', 'BNB', 'ORDI', 'DOGE', 'ARB'
  ];
  final selectedFixedCoin = RxList<String>(
      ['BTC', 'ETH', 'SOL', 'XRP', 'BNB', 'ORDI', 'DOGE', 'ARB']);
  final fetching = RxBool(false);
  StreamSubscription? _loginSubscription;
  StreamSubscription? _favoriteChangedSubscription;
  StreamSubscription? _orderChangedSubscription;
  @override
  GridDataSource dataSource = GridDataSource([]);

  @override
  void onInit() {
    dataSource.getColumns(Get.context!);
    _loginSubscription =
        AppConst.eventBus.on<LoginStatusChangeEvent>().listen((event) {
      onRefresh();
      startTimer();
    });
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

    FGBGEvents.stream.listen((event) async {
      if (event == FGBGType.foreground &&
          pageVisible &&
          AppConst.backgroundForAWhile) onRefresh();
    });
    super.onInit();
  }

  @override
  void onReady() {
    if (!StoreLogic.isLogin) {
      onRefresh();
      startTimer();
    }
    super.onReady();
  }

  @override
  void tapItem(MarkerTickerEntity item) {}

  bool _fetching = false;

  @override
  Future<void> onRefresh({bool showLoading = false}) async {
    if (_fetching) return;
    _fetching = true;
    TickersDataEntity? result;
    if (StoreLogic.isLogin) {
      result = await Apis().postSpotAgg(StoreLogic().spotCoinFilter ?? {},
          page: 1,
          size: 500, isFollow: true, extras: {'showToast': false})
          .catchError((e) => TickersDataEntity(list: []))
          .whenComplete(() => _fetching = false);
    } else {
      if (StoreLogic.to.favoriteSpot.isEmpty) {
        result = TickersDataEntity(list: []);
        _fetching = false;
      } else {
        result = await Apis().getSpotAgg(
          page: 1,
          size: 500,
          baseCoins: StoreLogic.to.favoriteSpot.join(','),
            )
            .whenComplete(() => _fetching = false);
      }
    }
    if (isLoading.value) isLoading.value = false;
    data.assignAll(result?.list ?? []);
    dataSource.items.assignAll(result?.list ?? []);
    dataSource.buildDataGridRows();
    dataSource.getColumns(Get.context!);
  }

  Timer? _pollingTimer;

  @override
  bool get pageVisible {
    if (Get.isBottomSheetOpen == true) return false;
    if (Get.currentRoute != '/') return false;
    if (Get.find<MainLogic>().selectedIndex.value != 1) return false;
    if (Get.find<MarketLogic>().tabCtrl.index != 1) return false;
    if (Get.find<SpotLogic>().tabCtrl.index != 0) return false;
    return true;
  }

  Future<void> startTimer() async {
    _pollingTimer = Timer.periodic(const Duration(seconds: 7), (timer) async {
      if (!AppConst.canRequest) return;
      if (!pageVisible) return;

      await onRefresh();
    });
  }

  void stopTimer() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
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
    _loginSubscription?.cancel();
    _favoriteChangedSubscription?.cancel();
    _orderChangedSubscription?.cancel();
    super.onClose();
  }
}
