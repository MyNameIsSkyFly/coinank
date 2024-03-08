import 'package:ank_app/modules/market/contract/contract_view.dart';
import 'package:ank_app/modules/market/spot/spot_view.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/home_search/home_search_view.dart';
import 'market_logic.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(MarketLogic());

  @override
  void initState() {
    logic.tabCtrl = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    indicatorColor: Colors.transparent,
                    labelStyle: Styles.tsBody_18m(context),
                    unselectedLabelStyle: Styles.tsSub_18(context).medium,
                    controller: logic.tabCtrl,
                    tabs: [
                      Tab(text: S.of(context).derivatives),
                      Tab(text: S.of(context).spot),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () => Get.toNamed(HomeSearchPage.routeName),
                    icon: Image.asset(
                      Assets.imagesIcSearch,
                      height: 20,
                      width: 20,
                      color: Theme.of(context).iconTheme.color,
                    )),
              ],
            ),
            Expanded(
                child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: logic.tabCtrl,
              children: const [
                AliveWidget(child: ContractPage()),
                AliveWidget(child: SpotPage()),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
