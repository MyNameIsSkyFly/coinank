import 'dart:async';

import 'package:ank_app/entity/coin_detail_contract_info_entity.dart';
import 'package:ank_app/entity/contract_market_entity.dart';
import 'package:ank_app/entity/event/event_coin_marked.dart';
import 'package:ank_app/modules/coin_detail/coin_detail_logic.dart';
import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_contract/_datagrid_source.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoinDetailContractLogic extends GetxController {
  final detailLogic = Get.find<CoinDetailLogic>();

  final info = Rxn<CoinDetailContractInfoEntity>();
  final typeIndex = 0.obs;
  late final gridSource = GridDataSource([], baseCoin);

  String get baseCoin => detailLogic.coin.baseCoin ?? '';
  Timer? _timer;
  final coin24hInfo = Rxn<ContractMarketEntity>();
  final marked = RxBool(false);
  late TabController tabCtrl;

  @override
  void onReady() {
    getGridData();
    getDetailInfo();
    getCoinInfo24h();
    initMarked();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!AppConst.canRequest ||
          Get.find<CoinDetailLogic>().tabController.index != 0) return;
      if (tabCtrl.index == 0) getGridData();
      getCoinInfo24h();
    });
  }

  Future<void> initMarked() async {
    if (!StoreLogic.isLogin) {
      marked.value = StoreLogic.to.favoriteContract.contains(baseCoin);
    } else {
      final tmp = await Apis().getFuturesBigData(
          page: 1, size: 1, sortType: '', baseCoins: baseCoin);
      marked.value = tmp?.list?.firstOrNull?.follow == true;
    }
  }

  Future<void> toggleMarked() async {
    if (!StoreLogic.isLogin) {
      if (marked.value) {
        await StoreLogic.to.removeFavoriteContract(baseCoin);
      } else {
        await StoreLogic.to.saveFavoriteContract(baseCoin);
      }
    } else {
      if (marked.value) {
        await Apis().getDelFollow(baseCoin: baseCoin);
      } else {
        await Apis().getAddFollow(baseCoin: baseCoin);
      }
    }
    marked.toggle();
    AppConst.eventBus
        .fire(EventCoinMarked(baseCoin: [baseCoin], follow: marked.value));
  }

  Future<void> getCoinInfo24h() async {
    final result = await Apis().getCoinInfo24h(detailLogic.coin.baseCoin ?? '');
    coin24hInfo.value = result;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void getGridData() {
    Apis()
        .getContractMarketData(baseCoin: baseCoin, sortType: 'descend')
        .then((value) {
      gridSource.items.clear();
      gridSource.items.addAll(value ?? []);
      gridSource.buildDataGridRows();
    });
  }

  Future<void> getDetailInfo() async {
    final result = await Apis().getCoinDetailContractInfo(baseCoin);
    info.value = result;
  }
}
