import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'liq_main_state.dart';

class LiqMainLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  final LiqMainState state = LiqMainState();

  @override
  void onInit() {
    super.onInit();
    state.tabController =
        TabController(initialIndex: state.index, length: 2, vsync: this);
  }
}
