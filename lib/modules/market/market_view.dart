import 'package:ank_app/res/export.dart';
import 'package:ank_app/modules/market/contract/contract_view.dart';
import 'package:ank_app/modules/market/contract_market/contract_market_view.dart';
import 'package:ank_app/modules/market/funding_rate/funding_rate_view.dart';
import 'package:ank_app/modules/market/liquidation_data/liquidation_data_view.dart';
import 'package:ank_app/modules/market/protfolio/protfolio_view.dart';
import 'package:ank_app/widget/custom_underliner_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'market_logic.dart';

class MarketPage extends StatelessWidget {
  MarketPage({super.key});

  final logic = Get.put(MarketLogic());
  final state = Get.find<MarketLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitleBar(
        customWidget: TabBar(
            controller: state.tabController,
            isScrollable: true,
            labelPadding: const EdgeInsets.only(left: 15, right: 5),
            labelColor: Theme.of(context).textTheme.bodyMedium?.color,
            labelStyle: Styles.tsBody_16m(context),
            unselectedLabelStyle: Styles.tsBody_16m(context),
            unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: const CustomUnderlineTabIndicator(),
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: S.current.s_crypto_coin),
              Tab(text: S.current.s_futures_market),
              Tab(text: S.current.s_liquidation_data),
              Tab(text: S.current.s_funding_rate),
              Tab(text: S.current.s_portfolio),
            ]),
      ),
      body: TabBarView(
        controller: state.tabController,
        children: [
          keepAlivePage(ContractPage()),
          keepAlivePage(ContractMarketPage()),
          keepAlivePage(LiquidationDataPage()),
          keepAlivePage(FundingRatePage()),
          keepAlivePage(ProtfolioPage()),
        ],
      ),
    );
  }
}
