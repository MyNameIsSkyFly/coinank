import 'package:get/get.dart';

import 'price_change_logic.dart';

class PriceChangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PriceChangeLogic());
  }
}
