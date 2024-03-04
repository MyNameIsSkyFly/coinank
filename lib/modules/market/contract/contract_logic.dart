import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contract_state.dart';

class ContractLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ContractState state = ContractState();

  @override
  void onInit() {
    super.onInit();
    state.tabController = TabController(length: 5, vsync: this);
  }

  void selectIndex(int index) {
    state.tabController?.animateTo(index);
  }
}
