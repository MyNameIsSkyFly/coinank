import 'dart:async';

import 'package:ank_app/entity/coin_detail_contract_info_entity.dart';
import 'package:ank_app/entity/contract_market_entity.dart';
import 'package:ank_app/http/apis.dart';
import 'package:ank_app/modules/coin_detail/coin_detail_logic.dart';
import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_contract/widget/_datagrid_source.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:get/get.dart';

class CoinDetailContractLogic extends GetxController {
  final detailLogic = Get.find<CoinDetailLogic>();

  // final coin24HDataList = RxList<ContractMarketEntity>();
  final info = Rxn<CoinDetailContractInfoEntity>();
  final coin24hInfo = Rxn<ContractMarketEntity>();
  final typeIndex = 0.obs;
  late final gridSource = GridDataSource([], baseCoin);
  String get baseCoin => detailLogic.coin.baseCoin ?? '';
  Timer? _timer;

  @override
  void onReady() {
    getGridData();
    getDetailInfo();
    getCoinInfo24h();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!Get.find<MainLogic>().state.appVisible ||
          Get.find<CoinDetailLogic>().tabController.index != 0) return;
      getGridData();
    });
    super.onReady();
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

  Future<void> getCoinInfo24h() async {
    final result = await Apis().getCoinInfo24h(baseCoin);
    coin24hInfo.value = result;
  }
}
