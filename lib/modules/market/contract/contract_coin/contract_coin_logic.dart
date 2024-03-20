import 'dart:async';

import 'package:ank_app/entity/event/event_coin_marked.dart';
import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/modules/market/contract/contract_coin/widgets/contract_coin_base_logic.dart';
import 'package:ank_app/modules/market/contract/contract_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

import '../../market_logic.dart';
import 'widgets/contract_coin_datagrid_source.dart';

class ContractCoinLogic extends GetxController
    implements ContractCoinBaseLogic {
  String? tag;

  final data = RxList<MarkerTickerEntity>();
  Timer? _pollingTimer;
  StreamSubscription? _favoriteChangedSubscription;

  @override
  GridDataSource dataSource = GridDataSource([]);

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
    if (AppConst.networkConnected == false) return;
    if (showLoading) Loading.show();
    final result = await Apis()
        .postFuturesBigData(
      StoreLogic().contractCoinFilter ?? {},
      page: 1,
      size: 500,
      tag: tag,
    )
        .whenComplete(() {
      Loading.dismiss();
      _fetching = false;
    });
    if (!StoreLogic.isLogin) _addFollowTag(result);
    data.assignAll(result?.list ?? []);
    dataSource.items.assignAll(data);
    dataSource.getColumns(Get.context!);
    dataSource.buildDataGridRows();
  }

  void _addFollowTag(TickersDataEntity? data) {
    final favorites = StoreLogic().favoriteContract;
    for (final item in data?.list ?? <MarkerTickerEntity>[]) {
      item.follow = favorites.contains(item.baseCoin);
    }
  }

  void _startTimer() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 7), (timer) async {
      // if (kDebugMode) return;
      if (Get.isBottomSheetOpen == true) return;
      if (Get.find<MarketLogic>().tabCtrl.index != 0) return;
      var index = Get.find<ContractLogic>().state.tabController?.index;
      if (Get.find<MainLogic>().state.selectedIndex.value == 1 &&
          Get.currentRoute == '/') {
        if (index == 1) {
          await onRefresh();
        }
      }
    });
  }

  bool firstLoginEvent = true;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
    onRefresh(showLoading: true);
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
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _favoriteChangedSubscription?.cancel();
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
