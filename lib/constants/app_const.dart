import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConst {
  AppConst._();

  static const isPlayVersion = bool.fromEnvironment('PLAY');
  static bool networkConnected = true;
  static final eventBus = EventBus();

  static String imageHost(String imageName) {
    return 'https://cdn01.coinank.com/image/coin/64/$imageName.png';
  }

  static double get width => MediaQuery.of(Get.context!).size.width;

  static double get height => MediaQuery.of(Get.context!).size.height;

  static double get statusBarHeight => MediaQuery.of(Get.context!).padding.top;

  static double get bottomBarHeight =>
      MediaQuery.of(Get.context!).padding.bottom;
  static PackageInfo? packageInfo;
  static AndroidDeviceInfo? deviceInfo;

  static String? get brand => deviceInfo?.brand.toLowerCase();
  static bool appVisible = true;

  static bool get canRequest => appVisible && networkConnected;
  static bool backgroundForAWhile = false;
  static bool foregroundForAWhile = true;
  static final routeObserver = RouteObserver<PageRoute>();
}
