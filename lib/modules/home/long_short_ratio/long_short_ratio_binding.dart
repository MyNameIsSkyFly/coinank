import 'package:get/get.dart';

import 'long_short_ratio_logic.dart';

class LongShortRatioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(LongShortRatioLogic.new);
  }
}
