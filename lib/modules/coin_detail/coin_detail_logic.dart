import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../entity/futures_big_data_entity.dart';

class CoinDetailLogic extends GetxController {
  late MarkerTickerEntity coin;
  late TabController tabController;
  bool supportContract = false;
  bool supportSpot = false;
  late bool toSpot;

  @override
  void onInit() {
    // ignore: avoid_dynamic_calls
    coin = Get.arguments['coin'];
    // ignore: avoid_dynamic_calls
    toSpot = Get.arguments['toSpot'] ?? false;
    supportSpot = coin.supportSpot ?? false;
    supportContract = coin.supportContract ?? false;
    super.onInit();
  }
}
