
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'favorite/spot_coin_logic_f.dart';

class SpotLogic extends GetxController {
  late TabController tabCtrl;

  @override
  void onInit() {
    Get.put(SpotCoinLogicF());
    super.onInit();
  }
}
