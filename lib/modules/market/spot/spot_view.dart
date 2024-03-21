import 'package:ank_app/modules/market/market_category/category_view.dart';
import 'package:ank_app/modules/market/spot/spot_coin/spot_coin_view.dart';
import 'package:ank_app/modules/market/spot/spot_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/custom_underliner_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'favorite/spot_coin_view_f.dart';

class SpotPage extends StatefulWidget {
  const SpotPage({super.key});

  @override
  State<SpotPage> createState() => _SpotPageState();
}

class _SpotPageState extends State<SpotPage>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(SpotLogic());

  @override
  void initState() {
    logic.tabCtrl = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: logic.tabCtrl,
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          labelPadding: const EdgeInsets.symmetric(horizontal: 10),
          labelColor: Theme.of(context).textTheme.bodyMedium?.color,
          labelStyle: Styles.tsBody_16m(context),
          unselectedLabelStyle: Styles.tsBody_16m(context),
          unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: const CustomUnderlineTabIndicator(),
          dividerColor: Theme.of(context).dividerTheme.color,
          tabs: [
            Tab(text: S.of(context).s_favorite),
            Tab(text: S.of(context).s_crypto_coin_short),
            Tab(text: S.of(context).category),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: logic.tabCtrl,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              AliveWidget(child: FSpotCoinView()),
              AliveWidget(child: SpotCoinView()),
              AliveWidget(child: ContractCategoryPage(isSpot: true)),
            ],
          ),
        ),
      ],
    );
  }
}

