import 'package:get/get.dart';

import 'contract_market_search_state.dart';

class ContractMarketSearchLogic extends GetxController {
  final ContractMarketSearchState state = ContractMarketSearchState();

  void search(String v) {
    state.list.value = state.originalList
        .where((element) => element.contains(v))
        .toList();
  }
}
