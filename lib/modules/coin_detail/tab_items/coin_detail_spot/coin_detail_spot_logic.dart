import 'package:ank_app/entity/contract_market_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

import '../../coin_detail_logic.dart';

class CoinDetailSpotLogic extends GetxController {
  final detailLogic = Get.find<CoinDetailLogic>();
  final coin24HDataList = RxList<ContractMarketEntity>();
  final coin24hInfo = Rxn<ContractMarketEntity>();

  String get baseCoin => detailLogic.coin.baseCoin ?? '';

  @override
  void onReady() {
    getGridData();
    getCoinInfo24h();
    super.onReady();
  }

  void getGridData() {
    Apis().getSpotTickers(baseCoin).then((value) {
      coin24HDataList.assignAll(value ?? []);
    });
  }

  Future<void> getCoinInfo24h() async {
    final result = await Apis().getCoinInfo24h(baseCoin);
    coin24hInfo.value = result;
  }
}
