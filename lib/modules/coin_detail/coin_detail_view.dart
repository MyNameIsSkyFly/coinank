import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_contract/coin_detail_contract_view.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'coin_detail_logic.dart';

class CoinDetailPage extends StatefulWidget {
  const CoinDetailPage({super.key});

  static const routeName = '/coin_detail';

  @override
  State<CoinDetailPage> createState() => _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(CoinDetailLogic());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 4, vsync: this, animationDuration: Duration.zero);
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
      ),
      body: Column(children: [
        TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            controller: _tabController,
            tabs: [
              Tab(text: '合约'),
              Tab(text: '合约'),
              Tab(text: '合约'),
              Tab(text: '合约'),
            ]),
        Expanded(
            child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
              const AliveWidget(child: CoinDetailContractView()),
              Container(
                color: Colors.blue,
              ),
              Container(
                color: Colors.yellow,
              ),
              Container(
                color: Colors.green,
              ),
            ]))
      ]),
    );
  }
}
