import 'package:ank_app/modules/home/liq_main/liq_hot_map/liq_hot_map_view.dart';
import 'package:ank_app/modules/home/liq_main/liq_map/liq_map_view.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/custom_underliner_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'liq_main_logic.dart';

class LiqMainPage extends StatelessWidget {
  LiqMainPage({super.key});

  static String routeName = '/home/liq_main';

  final logic = Get.find<LiqMainLogic>();
  final state = Get.find<LiqMainLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitleBar(
        customWidget: Stack(
          children: [

            Center(
              child: TabBar(
                controller: state.tabController,
                tabAlignment: TabAlignment.center,
                isScrollable: true,
                labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                labelColor: Theme.of(context).textTheme.bodyMedium?.color,
                labelStyle: Styles.tsBody_16m(context),
                unselectedLabelStyle: Styles.tsBody_16m(context),
                unselectedLabelColor:
                    Theme.of(context).textTheme.bodySmall?.color,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: const CustomUnderlineTabIndicator(),
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(text: S.current.s_liqmap),
                  Tab(text: S.current.s_liq_hot_map),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: Get.back,
                child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Image.asset(
                    Assets.commonIconArrowLeft,
                    width: 20,
                    height: 20,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: state.tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          keepAlivePage(LiqMapPage()),
          keepAlivePage(LiqHotMapPage()),
        ],
      ),
    );
  }
}
