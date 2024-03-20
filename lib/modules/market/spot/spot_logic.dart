import 'dart:async';

import 'package:ank_app/entity/event/event_coin_marked.dart';
import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/modules/market/market_logic.dart';
import 'package:ank_app/modules/market/spot/widgets/spot_coin_base_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/spot_coin_datagrid_source.dart';

class SpotLogic extends GetxController implements SpotCoinBaseLogic {
  @override
  GridDataSource dataSource = GridDataSource([]);
  final data = RxList<MarkerTickerEntity>();

  StreamSubscription? _favoriteChangedSubscription;
  RxBool isLoading = true.obs;
  late TabController tabCtrl;

  final fetching = RxBool(false);

  @override
  void onInit() {
    dataSource.getColumns(Get.context!);
    _startTimer();
    _favoriteChangedSubscription =
        AppConst.eventBus.on<EventCoinMarked>().listen(
      (event) {
        if (!event.isSpot) return;
        for (var e in event.baseCoin) {
          final item =
              data.firstWhereOrNull((element) => element.baseCoin == e);
          if (item == null) continue;
          item.follow = event.follow;
        }
      },
    );
    super.onInit();
  }

  @override
  Future<void> onRefresh({bool showLoading = false}) async {
    if (showLoading) Loading.show();
    final result = await Apis().getSpotAgg(page: 1, size: 500).whenComplete(() {
      if (showLoading) Loading.dismiss();
    });

    data.assignAll(result?.list ?? []);
    dataSource.items.assignAll(data);
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
        if (index == 1) {
          await onRefresh();
        }
      }
    });
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
    super.onClose();
  }
}
