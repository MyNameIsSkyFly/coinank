import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppConst {
  static String imageHost(String imageName) {
    return 'https://cdn01.coinsoto.com/image/coin/64/$imageName.png';
  }

  static double width = MediaQuery.of(Get.context!).size.width;
  static double height = MediaQuery.of(Get.context!).size.height;
  static double statusBarHeight = MediaQuery.of(Get.context!).padding.top;
  static double bottomBarHeight = MediaQuery.of(Get.context!).padding.bottom;
}
