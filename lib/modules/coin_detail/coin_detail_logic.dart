import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../entity/futures_big_data_entity.dart';

class CoinDetailLogic extends GetxController {
  late MarkerTickerEntity coin;
  late TabController tabController;
  bool supportContract = false;
  bool supportSpot = false;

  @override
  void onInit() {
    coin = Get.arguments['coin'];
    supportSpot = coin.supportSpot ?? false;
    supportContract = coin.supportContract ?? false;
    super.onInit();
  }
}
