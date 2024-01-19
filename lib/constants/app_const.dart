import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConst {
  static bool networkConnected = true;
  static const isPlayVersion = bool.fromEnvironment('PLAY');
  static final eventBus = EventBus();
  static String imageHost(String imageName) {
    return 'https://cdn01.coinsoto.com/image/coin/64/$imageName.png';
  }

  static double get width => MediaQuery.of(Get.context!).size.width;
  static double get height => MediaQuery.of(Get.context!).size.height;
  static double get statusBarHeight => MediaQuery.of(Get.context!).padding.top;
  static double get bottomBarHeight =>
      MediaQuery.of(Get.context!).padding.bottom;
  static PackageInfo? packageInfo;
  static AndroidDeviceInfo? deviceInfo;
}
