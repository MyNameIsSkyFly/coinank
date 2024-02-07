import 'package:ank_app/modules/market/contract/contract_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../entity/futures_big_data_entity.dart';

class CoinDetailLogic extends GetxController {
  late MarkerTickerEntity coin;
  final contractLogic = Get.find<ContractLogic>();
  late TabController tabController;
  @override
  void onInit() {
    coin = Get.arguments['coin'];
    super.onInit();
  }
}
