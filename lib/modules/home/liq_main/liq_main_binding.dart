import 'package:get/get.dart';

import 'liq_main_logic.dart';

class LiqMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(LiqMainLogic.new);
  }
}
