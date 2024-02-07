import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../chart/chart_view.dart';
import '../home/home_view.dart';
import '../market/market_view.dart';
import '../setting/setting_view.dart';

class MainState {
  RxInt selectedIndex = 0.obs;
  late List<Widget> tabPage;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  InAppWebViewController? webViewController;
  bool isFirstKLine = true;
  bool appVisible = true;

  MainState() {
    tabPage = [
      const HomePage(),
      MarketPage(),
      CommonWebView(
        showLoading: true,
        safeArea: true,
        url: Urls.urlProChart,
        urlGetter: () => Urls.urlProChart,
        onWebViewCreated: (controller) => webViewController = controller,
      ),
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
