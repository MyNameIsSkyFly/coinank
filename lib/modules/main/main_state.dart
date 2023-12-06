import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class MainState {
  RxInt selectedIndex = 0.obs;
  late List<Widget> tabPage;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  InAppWebViewController? webViewController;
  bool isFirstKLine = true;
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
