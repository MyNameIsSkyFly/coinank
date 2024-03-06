import 'dart:async';

import 'package:ank_app/entity/contract_market_entity.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

import '../../coin_detail_logic.dart';
import '_datagrid_source.dart';

class CoinDetailSpotLogic extends GetxController {
  final detailLogic = Get.find<CoinDetailLogic>();
  late final gridSource = GridDataSource([], baseCoin);
  final coin24hInfo = Rxn<ContractMarketEntity>();

  String get baseCoin => detailLogic.coin.baseCoin ?? '';
  Timer? _timer;
  final marked = RxBool(false);
  @override
  void onReady() {
    getGridData();
    getCoinInfo24h();
    initMarked();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!Get.find<MainLogic>().state.appVisible ||
          Get.find<CoinDetailLogic>().tabController.index != 1) return;
      getGridData();
      getCoinInfo24h();
    });
    super.onReady();
  }

  Future<void> initMarked() async {
    if (!StoreLogic.isLogin) {
      marked.value = StoreLogic.to.favoriteSpot.contains(baseCoin);
    } else {
      final tmp = await Apis()
          .getSpotAgg(page: 1, size: 1, sortType: '', baseCoins: baseCoin);
      marked.value = tmp?.list?.firstOrNull?.follow == true;
    }
  }

  Future<void> toggleMarked() async {
    if (!StoreLogic.isLogin) {
      if (marked.value) {
        StoreLogic.to.removeFavoriteSpot(baseCoin);
      } else {
        StoreLogic.to.saveFavoriteSpot(baseCoin);
      }
    } else {
      if (marked.value) {
        await Apis().getDelFollow(baseCoin: baseCoin, type: 4);
      } else {
        await Apis().getAddFollow(baseCoin: baseCoin, type: 4);
      }
    }
    marked.toggle();
  }

  Future<void> getCoinInfo24h() async {
    final result = await Apis()
        .getCoinInfo24h(detailLogic.coin.baseCoin ?? '', productType: 'SPOT');
    coin24hInfo.value = result;
  }

  void getGridData() {
    Apis().getSpotTickers(baseCoin).then((value) {
      gridSource.items.clear();
      gridSource.items.addAll(value ?? []);
      gridSource.buildDataGridRows();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
