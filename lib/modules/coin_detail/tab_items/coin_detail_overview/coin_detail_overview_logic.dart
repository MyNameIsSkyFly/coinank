import 'package:ank_app/entity/coin_detail_entity.dart';
import 'package:ank_app/entity/market_cap_entity.dart';
import 'package:ank_app/modules/coin_detail/coin_detail_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

class CoinDetailOverviewLogic extends GetxController {
  final detailLogic = Get.find<CoinDetailLogic>();

  final coinDetail = Rxn<CoinDetailEntity>();
  final capList = RxList<MarketCapEntity>();

  String get baseCoin => detailLogic.coin.baseCoin ?? '';

  @override
  void onReady() {
    getCoinDetail();
    getMarketCapTopList();
    super.onReady();
  }

  void getCoinDetail() {
    Apis().getCoinDetail(baseCoin).then((value) {
      coinDetail.value = value;
    });
  }

  void getMarketCapTopList() {
    Apis().getMarketCapTop(10).then((value) {
      capList.value = value ?? [];
    });
  }
}
