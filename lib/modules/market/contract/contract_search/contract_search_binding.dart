import 'package:get/get.dart';

import 'contract_search_logic.dart';

class ContractSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ContractSearchLogic());
  }
}
