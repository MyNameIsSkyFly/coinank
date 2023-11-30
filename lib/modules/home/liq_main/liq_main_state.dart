import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ank_app/modules/home/liq_main/liq_hot_map/liq_hot_map_view.dart';
import 'package:ank_app/modules/home/liq_main/liq_map/liq_map_view.dart';

class LiqMainState {
   RxInt index = 0.obs;
  TabController? tabController;
  late List<Widget> tabPage;

  LiqMainState() {
    index.value = Get.arguments as int;
    tabPage = [
      LiqMapPage(),
      LiqHotMapPage(),
    ];
  }
}
