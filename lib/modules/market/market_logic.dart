import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'market_state.dart';

class MarketLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  final MarketState state = MarketState();

  @override
  void onInit() {
    super.onInit();
    state.tabController = TabController(length: 5, vsync: this);
  }

  void selectIndex(int index) {
    state.tabController?.animateTo(index);
  }
}
