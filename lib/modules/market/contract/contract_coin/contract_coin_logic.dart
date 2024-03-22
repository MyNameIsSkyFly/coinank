import 'dart:async';

import 'package:ank_app/entity/event/event_coin_marked.dart';
import 'package:ank_app/entity/event/event_coin_order_changed.dart';
import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/modules/market/contract/contract_coin/widgets/contract_coin_base_logic.dart';
import 'package:ank_app/modules/market/contract/contract_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';

import '../../market_logic.dart';
import 'widgets/contract_coin_datagrid_source.dart';

class ContractCoinLogic extends GetxController
    implements ContractCoinBaseLogic {
  ContractCoinLogic({required this.isCategory});

  final bool isCategory;

  final isInitializing = RxBool(true);
  final tag = RxnString();

  final data = RxList<MarkerTickerEntity>();
  Timer? _pollingTimer;
  StreamSubscription? _favoriteChangedSubscription;
  StreamSubscription? _orderChangedSubscription;

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
    if (item == null) return;
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
    AppConst.eventBus
        .fire(EventCoinMarked(baseCoin: [baseCoin], follow: item.follow));
  }

  bool _fetching = false;

  @override
  Future<void> onRefresh({bool showLoading = false}) async {
    if (_fetching) return;
    _fetching = true;
    if (showLoading) Loading.show();
    final result = await Apis()
        .postFuturesBigData(
      StoreLogic().contractCoinFilter ?? {},
      page: 1,
      size: 500,
      tag: tag.value,
    )
        .whenComplete(() {
      Loading.dismiss();
      _fetching = false;
    });
    if (!StoreLogic.isLogin) _addFollowTag(result);
    if (isInitializing.value) isInitializing.value = false;
    data.assignAll(result?.list ?? []);
    dataSource.items.assignAll(data);
    dataSource.buildDataGridRows();
    dataSource.getColumns(Get.context!);
  }

  void _addFollowTag(TickersDataEntity? data) {
    final favorites = StoreLogic().favoriteContract;
    for (final item in data?.list ?? <MarkerTickerEntity>[]) {
      item.follow = favorites.contains(item.baseCoin);
    }
  }

  @override
  bool get pageVisible {
    if (Get.currentRoute != '/') return false;
    if (Get.isBottomSheetOpen == true) return false;
    if (Get.find<MainLogic>().state.selectedIndex.value != 1) return false;
    if (Get.find<MarketLogic>().tabCtrl.index != 0) return false;
    var index = Get.find<ContractLogic>().state.tabController?.index;
    if (index != 1) return false;
    return true;
  }

  void _startTimer() {
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

  bool firstLoginEvent = true;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
    dataSource.isCategory = isCategory;
    dataSource.getColumns(Get.context!);
    _favoriteChangedSubscription =
        AppConst.eventBus.on<EventCoinMarked>().listen(
      (event) {
        if (event.isSpot) return;
        for (var e in event.baseCoin) {
          final item =
              data.firstWhereOrNull((element) => element.baseCoin == e);
          if (item == null) continue;
          item.follow = event.follow;
        }
      },
    );
    _orderChangedSubscription =
        AppConst.eventBus.on<EventCoinOrderChanged>().listen((event) {
      if (event.isSpot) return;
      if (isCategory != event.isCategory) return;
      dataSource.getColumns(Get.context!);
      dataSource.buildDataGridRows();
    });

    FGBGEvents.stream.listen((event) async {
      if (event == FGBGType.foreground &&
          pageVisible &&
          AppConst.backgroundForAWhile) onRefresh();
    });
  }

  @override
  void onReady() {
    onRefresh(showLoading: true);
    super.onReady();
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
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
