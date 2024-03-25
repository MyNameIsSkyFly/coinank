import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'spot/spot_logic.dart';

class MarketLogic extends GetxController {
  late TabController tabCtrl;

  void selectIndex(int index) {
    tabCtrl.animateTo(index);
  }

  @override
  void onInit() {
    Get.put(SpotLogic());
    super.onInit();
  }
}
