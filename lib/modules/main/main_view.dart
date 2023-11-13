import 'package:ank_app/generated/l10n.dart';
import 'package:ank_app/modules/main/main_state.dart';
import 'package:ank_app/res/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_logic.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final logic = Get.find<MainLogic>();
  final state = Get.find<MainLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: state.pageController,
        itemCount: state.tabPage.length,
        itemBuilder: (context, index) => state.tabPage[index],
      ),
      bottomNavigationBar: Obx(() {
        return MyBottomBar(
          items: [
            BottomBarItem(
              'assets/images/bottom_bar/home.png',
              'assets/images/bottom_bar/home.png',
              S.current.s_home,
            ),
            BottomBarItem(
              'assets/images/bottom_bar/market.png',
              'assets/images/bottom_bar/market.png',
              S.current.s_tickers,
            ),
            BottomBarItem(
              'assets/images/bottom_bar/books.png',
              'assets/images/bottom_bar/books.png',
              S.current.s_order_flow,
            ),
            BottomBarItem(
              'assets/images/bottom_bar/chart.png',
              'assets/images/bottom_bar/chart.png',
              S.current.s_chart,
            ),
            BottomBarItem(
              'assets/images/bottom_bar/set.png',
              'assets/images/bottom_bar/set.png',
              S.current.s_setting,
            ),
          ],
          currentIndex: state.selectedIndex.value,
          onTap: (int index) => logic.selectTab(index),
        );
      }),
    );
  }
}

class MyBottomBar extends StatelessWidget {
  const MyBottomBar({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onTap,
  });

  final List<BottomBarItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withOpacity(0.1),width: 1)),
      ),
      child: SafeArea(
        child: Row(
          children: List.generate(
            items.length,
                (index) => _createItem(
              index,
              MediaQuery.of(context).size.width / 5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _createItem(int i, double itemWidth) {
    BottomBarItem item = items[i];
    bool selected = i == currentIndex;
    return InkWell(
      onTap: onTap != null
          ? () {
        if (onTap != null) {
          onTap!(i);
        }
      }
          : null,
      child: Container(
        width: itemWidth,
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Offstage(
              offstage: selected,
              child: Image.asset(
                item.icon,
                width: 25,
                height: 25,
                color: LightColors.colorText,
              ),
            ),
            Offstage(
              offstage: !selected,
              child: Image.asset(
                item.activeIcon,
                width: 25,
                height: 25,
                color: LightColors.mainBlue,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              item.title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: selected ? LightColors.mainBlue : LightColors.colorText,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}