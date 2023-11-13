import 'package:ank_app/widget/keep_alive_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainState {
  late PageController pageController;
  RxInt selectedIndex = 0.obs;
  late List<Widget> tabPage;
  late List<BottomBarItem> tabBar;

  MainState() {
    pageController = PageController(initialPage: 0);
    tabPage = [
      keepAlivePage(Center(child: Text('开发中0'))),
      keepAlivePage(Center(child: Text('开发中1'))),
      keepAlivePage(Center(child: Text('开发中2'))),
      keepAlivePage(Center(child: Text('开发中3'))),
      keepAlivePage(Center(child: Text('开发中4'))),
    ];
    tabBar = [
      BottomBarItem(
        'assets/images/bottom_bar/home.png',
        'assets/images/bottom_bar/home.png',
        '首页',
      ),
      BottomBarItem(
        'assets/images/bottom_bar/market.png',
        'assets/images/bottom_bar/market.png',
        '行情',
      ),
      BottomBarItem(
        'assets/images/bottom_bar/books.png',
        'assets/images/bottom_bar/books.png',
        '订单流',
      ),
      BottomBarItem(
        'assets/images/bottom_bar/chart.png',
        'assets/images/bottom_bar/chart.png',
        '图表',
      ),
      BottomBarItem(
        'assets/images/bottom_bar/set.png',
        'assets/images/bottom_bar/set.png',
        '设置',
      ),
    ];
  }
}

class BottomBarItem {
  final String icon; //未选中状态图标
  final String activeIcon; //选中状态图标
  final String title; //文字

  BottomBarItem(this.icon, this.activeIcon, this.title);
}
