import 'package:ank_app/entity/coin_detail_entity.dart';
import 'package:ank_app/entity/contract_market_entity.dart';
import 'package:ank_app/http/apis.dart';
import 'package:ank_app/modules/coin_detail/coin_detail_logic.dart';
import 'package:get/get.dart';

class CoinDetailContractLogic extends GetxController {
  final detailLogic = Get.find<CoinDetailLogic>();
  final coin24HDataList = RxList<ContractMarketEntity>();
  final info = Rxn<CoinDetailContractInfoEntity>();
  final coin24hInfo = Rxn<ContractMarketEntity>();

  String get baseCoin => detailLogic.coin.baseCoin ?? '';

  @override
  void onReady() {
    getGridData();
    getDetailInfo();
    getCoinInfo24h();
    super.onReady();
  }

  void getGridData() {
    Apis()
        .getContractMarketData(baseCoin: baseCoin, sortType: 'descend')
        .then((value) {
      coin24HDataList.assignAll(value ?? []);
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
