import 'package:ank_app/modules/market/market_view.dart';
import 'package:ank_app/modules/order_flow/order_flow_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../chart/chart_view.dart';
import '../home/home_view.dart';
import '../setting/setting_view.dart';

class MainState {
  RxInt selectedIndex = 0.obs;
  late List<Widget> tabPage;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  InAppWebViewController? webViewController;
  bool isFirstKLine = true;

  MainState() {
    tabPage = [
      const HomePage(),
      const MarketPage(),
      const OrderFlowPage(),
      const ChartPage(),
      const SettingPage(),
    ];
  }
}

class BottomBarItem {
  final String icon; //未选中状态图标
  // final String activeIcon; //选中状态图标
  final String title; //文字

  BottomBarItem(
    this.icon,
    //this.activeIcon,
    this.title,
  );
}
