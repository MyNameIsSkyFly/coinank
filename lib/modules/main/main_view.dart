import 'package:ank_app/generated/assets.dart';
import 'package:ank_app/generated/l10n.dart';
import 'package:ank_app/modules/chart/chart_drawer/chart_drawer_view.dart';
import 'package:ank_app/modules/main/main_state.dart';
import 'package:ank_app/res/light_colors.dart';
import 'package:ank_app/res/styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'main_logic.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final logic = Get.find<MainLogic>();
  final state = Get.find<MainLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: state.scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Obx(() {
        return IndexedStack(index: logic.state.selectedIndex.value, children: state.tabPage);
      }),
      drawerEnableOpenDragGesture: false,
      bottomNavigationBar: Obx(() {
        return MyBottomBar(
          items: [
            BottomBarItem(
              Assets.bottomBarHome,
              S.current.s_home,
            ),
            BottomBarItem(
              Assets.bottomBarMarket,
              S.current.s_tickers,
            ),
            BottomBarItem(
              Assets.bottomBarBooks,
              S.current.s_order_flow,
            ),
            BottomBarItem(
              Assets.bottomBarChart,
              S.current.s_chart,
            ),
            BottomBarItem(
              Assets.bottomBarSet,
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
      padding: EdgeInsets.only(bottom: Get.mediaQuery.viewPadding.bottom),
      decoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarTheme.color,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, -1), blurRadius: 4)
          ]),
      child: Row(
        children: List.generate(
          items.length,
          (index) => _createItem(
            index,
            MediaQuery.of(context).size.width / 5,
            context,
          ),
        ),
      ),
    );
  }

  Widget _createItem(int i, double itemWidth, BuildContext context) {
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
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Offstage(
              offstage: !selected,
              child: Image.asset(
                item.icon,
                width: 25,
                height: 25,
                color: LightColors.mainBlue,
              ),
            ),
            const Gap(3),
            Text(
              item.title,
              style: Styles.tsBody_11(context)
                  .copyWith(color: selected ? Styles.cMain : null),
            ),
          ],
        ),
      ),
    );
  }
}
