import 'package:ank_app/entity/hold_address_entity.dart';
import 'package:ank_app/modules/coin_detail/coin_detail_logic.dart';
import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_hold/_event.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

class CoinDetailHoldLogic extends GetxController {
  final detailLogic = Get.find<CoinDetailLogic>();

  final flowAddressList = RxList<HoldAddressItemEntity>();
  final topAddressList = RxList<HoldAddressItemEntity>();
  HoldAddressEntity? holdAddressEntity;

  String get baseCoin => detailLogic.coin.baseCoin ?? '';

  String get code => detailLogic.coin.symbol ?? '';

  @override
  void onReady() {
    getMarketCapTopList();
  }

  void getMarketCapTopList() {
    Apis().getHoldAddress(baseCoin).then((value) {
      AppConst.eventBus.fire(EventHoldLoaded(value));
      topAddressList.assignAll(value?.topAddressList ?? []);
      flowAddressList.assignAll(value?.flowAddressList ?? []);
    });
  }
}
