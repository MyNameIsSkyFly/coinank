import 'package:get/get.dart';

import 'contract_market_search_logic.dart';

class ContractMarketSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(ContractMarketSearchLogic.new);
  }
}
