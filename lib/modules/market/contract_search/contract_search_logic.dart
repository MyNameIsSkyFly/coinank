import 'package:get/get.dart';

import 'contract_search_state.dart';

class ContractSearchLogic extends GetxController {
  final ContractSearchState state = ContractSearchState();

  void search(String v) {
    state.list.value = state.originalList
        .where((element) => element.symbol!.contains(v))
        .toList();
  }
}
