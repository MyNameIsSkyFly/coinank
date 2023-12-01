import 'package:ank_app/modules/chart/chart_view.dart';
import 'package:ank_app/modules/market/market_view.dart';
import 'package:ank_app/modules/setting/setting_view.dart';
import 'package:ank_app/widget/keep_alive_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../widget/common_webview.dart';
import '../home/home_view.dart';

class MainState {
  RxInt selectedIndex = 0.obs;
  late List<Widget> tabPage;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  InAppWebViewController? webViewController;
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
