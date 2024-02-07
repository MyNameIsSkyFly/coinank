import 'dart:async';

import 'package:ank_app/entity/contract_market_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

import '../../coin_detail_logic.dart';
import 'widget/_datagrid_source.dart';

class CoinDetailSpotLogic extends GetxController {
  final detailLogic = Get.find<CoinDetailLogic>();
  final coin24hInfo = Rxn<ContractMarketEntity>();
  late final gridSource = GridDataSource([], baseCoin);

  String get baseCoin => detailLogic.coin.baseCoin ?? '';
  Timer? _timer;
  @override
  void onReady() {
    getGridData();
    getCoinInfo24h();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (Get.find<CoinDetailLogic>().tabController.index != 1) return;
      getGridData();
    });
    super.onReady();
  }

  void getGridData() {
    Apis().getSpotTickers(baseCoin).then((value) {
      gridSource.items.clear();
      gridSource.items.addAll(value ?? []);
      gridSource.buildDataGridRows();
    });
  }

  Future<void> getCoinInfo24h() async {
    final result = await Apis().getCoinInfo24h(baseCoin);
    coin24hInfo.value = result;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
