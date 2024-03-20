import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contract_state.dart';

class ContractLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ContractState state = ContractState();

  @override
  void onInit() {
    super.onInit();
    state.tabController =
        TabController(length: 6, vsync: this, initialIndex: 0);
  }

  void selectIndex(int index) {
    state.tabController?.animateTo(index);
  }
}
