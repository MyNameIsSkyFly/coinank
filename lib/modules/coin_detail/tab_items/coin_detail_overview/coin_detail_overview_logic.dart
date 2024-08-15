import 'dart:async';

import 'package:ank_app/entity/coin_detail_entity.dart';
import 'package:ank_app/entity/market_cap_entity.dart';
import 'package:ank_app/modules/coin_detail/coin_detail_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

import '../../../../entity/contract_market_entity.dart';

class CoinDetailOverviewLogic extends GetxController {
  final detailLogic = Get.find<CoinDetailLogic>();

  final coinDetail = Rxn<CoinDetailEntity>();
  final capList = RxList<MarketCapEntity>();

  String get baseCoin => detailLogic.coin.baseCoin ?? '';
  final coin24hInfo = Rxn<ContractMarketEntity>();
  Timer? _timer;
  @override
  void onReady() {
    getCoinDetail();
    getMarketCapTopList();
    getCoinInfo24h();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!AppConst.canRequest) return;
      getCoinInfo24h();
    });
  }

  Future<void> getCoinInfo24h() async {
    final result = await Apis().getCoinInfo24h(detailLogic.coin.baseCoin ?? '',
        productType: detailLogic.coin.supportSpot == true ? 'SPOT' : 'SWAP');
    coin24hInfo.value = result;
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

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
