import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_contract/coin_detail_contract_view.dart';
import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_spot/coin_detail_spot_view.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'coin_detail_logic.dart';
import 'tab_items/coin_detail_hold/coin_detail_hold_view.dart';
import 'tab_items/coin_detail_overview/coin_detail_overview_view.dart';

class CoinDetailPage extends StatefulWidget {
  const CoinDetailPage({super.key});

  static const routeName = '/coin_detail';

  @override
  State<CoinDetailPage> createState() => _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage>
    with TickerProviderStateMixin {
  final logic = Get.put(CoinDetailLogic());

  @override
  void initState() {
    super.initState();
    logic.tabController = TabController(
      length: 2 + (logic.supportContract ? 1 : 0) + (logic.supportSpot ? 1 : 0),
      vsync: this,
      animationDuration: Duration.zero,
      initialIndex: logic.toSpot
          ? logic.supportContract
              ? 1
              : 0
          : 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            ImageUtil.networkImage(
              AppConst.imageHost(logic.coin.baseCoin ?? ''),
              width: 24,
              height: 24,
            ),
            const Gap(5),
            Text(logic.coin.baseCoin ?? ''),
          ],
        ),
        titleTextStyle:
            Styles.tsBody_18(context).copyWith(fontWeight: FontWeight.w700),
        actions: [
          IconButton(
            style: IconButton.styleFrom(visualDensity: VisualDensity.compact),
            icon: ImageIcon(const AssetImage(Assets.commonIcShare),
                size: 20, color: Styles.cBody(context)),
            onPressed: AppUtil.shareImage,
          ),
        ],
      ),
      body: Column(children: [
        TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            controller: logic.tabController,
            indicator: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Styles.cMain, width: 2))),
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: Styles.tsBody_14m(context),
            unselectedLabelStyle: Styles.tsSub_14m(context),
            tabs: [
              if (logic.supportContract) Tab(text: S.of(context).derivatives),
              if (logic.supportSpot) Tab(text: S.of(context).spot),
              Tab(text: S.of(context).overview),
              Tab(text: S.of(context).holding),
            ]),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: logic.tabController,
            children: [
              if (logic.supportContract)
                const AliveWidget(child: CoinDetailContractView()),
              if (logic.supportSpot)
                const AliveWidget(child: CoinDetailSpotView()),
              const AliveWidget(child: CoinDetailOverviewView()),
              const AliveWidget(child: CoinDetailHoldView()),
            ],
          ),
        )
      ]),
    );
  }
}
