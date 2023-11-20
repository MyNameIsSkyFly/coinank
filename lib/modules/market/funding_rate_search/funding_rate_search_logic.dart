import 'package:get/get.dart';

import 'funding_rate_search_state.dart';

class FundingRateSearchLogic extends GetxController {
  final FundingRateSearchState state = FundingRateSearchState();

  void search(String v) {
    state.data.value =
        state.originalData.where((element) => element.contains(v)).toList();
  }

  void tapItem(String item) {
    if (state.selects.contains(item)) {
      if (item == 'ALL') {
        state.selects.clear();
      } else {
        state.selects.remove(item);
      }
    } else {
      if (item == 'ALL') {
        state.selects.value = ['ALL'];
        state.selects.addAll(state.originalData);
      } else {
        state.selects.add(item);
      }
    }
  }
}
