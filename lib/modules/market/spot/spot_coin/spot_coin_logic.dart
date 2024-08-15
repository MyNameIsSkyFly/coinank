import 'dart:async';

import 'package:ank_app/entity/event/event_coin_marked.dart';
import 'package:ank_app/entity/event/event_coin_order_changed.dart';
import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/modules/market/market_logic.dart';
import 'package:ank_app/modules/market/spot/widgets/spot_coin_base_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

import '../../../../entity/event/fgbg_type.dart';
import '../spot_logic.dart';
import '../widgets/spot_coin_datagrid_source.dart';

class SpotCoinLogic extends GetxController implements SpotCoinBaseLogic {
  SpotCoinLogic({required this.isCategory});

  final bool isCategory;
  final tag = RxnString();
  final isInitializing = RxBool(true);
  @override
  GridDataSource dataSource = GridDataSource([]);
  final data = RxList<MarkerTickerEntity>();

  StreamSubscription? _favoriteChangedSubscription;
  StreamSubscription? _orderChangedSubscription;
  RxBool isLoading = true.obs;

  final fetching = RxBool(false);

  @override
  void onInit() {
    dataSource.getColumns(Get.context!);
    startTimer();
    _favoriteChangedSubscription =
        AppConst.eventBus.on<EventCoinMarked>().listen(
      (event) {
        if (!event.isSpot) return;
        for (final e in event.baseCoin) {
          final item =
              data.firstWhereOrNull((element) => element.baseCoin == e);
          if (item == null) continue;
          item.follow = event.follow;
        }
      },
    );
    _orderChangedSubscription =
        AppConst.eventBus.on<EventCoinOrderChanged>().listen((event) {
      if (!event.isSpot) return;
      if (isCategory != event.isCategory) return;
      dataSource
        ..getColumns(Get.context!)
        ..buildDataGridRows();
    });

    AppConst.eventBus.on<FGBGType>().listen((event) async {
      if (event == FGBGType.foreground &&
          pageVisible &&
          AppConst.backgroundForAWhile) {
        Future.delayed(const Duration(milliseconds: 100), onRefresh);
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    onRefresh(showLoading: true);
  }

  bool _fetching = false;

  @override
  Future<void> onRefresh({bool showLoading = false}) async {
    if (_fetching) return;
    _fetching = true;
    if (showLoading) Loading.show();
    final result = await Apis()
        .postSpotAgg(
            (isCategory
                    ? StoreLogic().spotCoinFilterCategory
                    : StoreLogic().spotCoinFilter) ??
                {},
            page: 1,
            size: 500,
            tag: tag.value)
        .whenComplete(() {
      if (showLoading) Loading.dismiss();
    }).whenComplete(() => _fetching = false);

    data.assignAll(result?.list ?? []);
    if (isInitializing.value) isInitializing.value = false;
    dataSource.items.assignAll(data);
    dataSource
      ..buildDataGridRows()
      ..getColumns(Get.context!);
  }

  Timer? _pollingTimer;

  @override
  bool get pageVisible {
    if (Get.isBottomSheetOpen == true) return false;
    if (Get.currentRoute != '/') return false;
    if (Get.find<MainLogic>().selectedIndex.value != 1) return false;
    if (Get.find<MarketLogic>().tabCtrl.index != 1) return false;
    if (Get.find<SpotLogic>().tabCtrl.index != 1) return false;
    return true;
  }

  Future<void> startTimer() async {
    _pollingTimer = Timer.periodic(const Duration(seconds: 7), (timer) async {
      if (!AppConst.canRequest) return;
      if (isCategory) {
        await onRefresh();
        return;
      }
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
    if (item == null) return;
    if (!StoreLogic.isLogin) {
      if (item.follow == true) {
        await StoreLogic.to.removeFavoriteSpot(item.baseCoin!);
        AppUtil.showToast(S.current.removedFromFavorites);
        item.follow = false;
      } else {
        await StoreLogic.to.saveFavoriteSpot(item.baseCoin!);
        AppUtil.showToast(S.current.addedToFavorites);
        item.follow = true;
      }
    } else {
      if (item.follow == true) {
        await Apis().getDelFollow(baseCoin: item.baseCoin!, type: 4);
        AppUtil.showToast(S.current.removedFromFavorites);
        item.follow = false;
      } else {
        await Apis().getAddFollow(baseCoin: item.baseCoin!, type: 4);
        AppUtil.showToast(S.current.addedToFavorites);
        item.follow = true;
      }
    }
    AppConst.eventBus.fire(EventCoinMarked(
        baseCoin: [baseCoin], follow: item.follow, isSpot: true));
  }

  @override
  void tapItem(MarkerTickerEntity item) {}

  @override
  void onClose() {
    _pollingTimer?.cancel();
    _favoriteChangedSubscription?.cancel();
    _orderChangedSubscription?.cancel();
    super.onClose();
  }
}
