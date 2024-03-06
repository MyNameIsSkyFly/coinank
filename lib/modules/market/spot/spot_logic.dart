import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

import '_datagrid_source.dart';
import 'spot_logic_mixin.dart';

class SpotLogic extends GetxController with SpotLogicMixin {
  late final gridSource = GridDataSource([]);
  final data = RxList<MarkerTickerEntity>();

  late final gridSourceF = GridDataSource([]);
  final dataF = RxList<MarkerTickerEntity>();
  RxBool isLoading = true.obs;
  final fixedCoin = [
    //line
    'BTC', 'ETH', 'SHIB', 'FDUSD', 'SOL', 'DOGE', 'XRP', 'USDC'
  ];
  final selectedFixedCoin = RxList<String>(
      ['BTC', 'ETH', 'SHIB', 'FDUSD', 'SOL', 'DOGE', 'XRP', 'USDC']);
  final fetching = RxBool(false);

  @override
  void onInit() {
    getColumns(Get.context!);
    super.onInit();
  }

  Future<void> getMarketData({bool showLoading = false}) async {
    if (showLoading) Loading.show();
    final result = await Apis().getSpotAgg(page: 1, size: 500).whenComplete(() {
      if (showLoading) Loading.dismiss();
    });

    data.assignAll(result?.list ?? []);
    gridSource.items.assignAll(result?.list ?? []);
    gridSource.buildDataGridRows();
    columns.refresh();
  }

  Future<void> getMarketDataF() async {
    TickersDataEntity? result;
    if (StoreLogic.isLogin) {
      result = await Apis().getSpotAgg(page: 1, size: 500, isFollow: true);
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
    dataF.assignAll(result?.list ?? []);
    gridSourceF.items.assignAll(result?.list ?? []);
    gridSourceF.buildDataGridRows();
    columns.refresh();
  }

  Future<void> tapCollect(MarkerTickerEntity item) async {
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
        await Apis().getDelFollow(baseCoin: item.baseCoin!);
        AppUtil.showToast(S.current.removedFromFavorites);
        item.follow = false;
      } else {
        await Apis().getAddFollow(baseCoin: item.baseCoin!);
        AppUtil.showToast(S.current.addedToFavorites);
        item.follow = true;
      }
    }
    getMarketDataF();
  }

  Future<void> tapCollectF(String? baseCoin) async {
    final item =
        dataF.firstWhereOrNull((element) => element.baseCoin == baseCoin);
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
    data.where((p0) => p0.baseCoin == item?.baseCoin).firstOrNull?.follow =
        item?.follow;
    await getMarketDataF();
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
    for (var element in data) {
      if (selectedFixedCoin.contains(element.baseCoin)) {
        element.follow = true;
      }
    }
    getMarketDataF();
    selectedFixedCoin.clear();
  }
}
