import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiqMainState {
  late int index;
  TabController? tabController;

  LiqMainState() {
    index = Get.arguments as int;
  }
}
