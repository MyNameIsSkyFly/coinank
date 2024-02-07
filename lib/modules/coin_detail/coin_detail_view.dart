import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_contract/coin_detail_contract_view.dart';
import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_spot/coin_detail_spot_view.dart';
import 'package:ank_app/modules/market/contract/contract_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/cupertino.dart';
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
    return Stack(
      children: [
        Scaffold(
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
            actions: [
              IconButton(
                style:
                    IconButton.styleFrom(visualDensity: VisualDensity.compact),
                icon:
                    const ImageIcon(AssetImage(Assets.commonIcShare), size: 20),
                onPressed: () => AppUtil.shareImage(),
              ),
              ObxValue((RxBool marked) {
                return IconButton(
                  style: IconButton.styleFrom(
                      visualDensity: VisualDensity.compact),
                  icon: Icon(
                      marked.value
                          ? CupertinoIcons.star_fill
                          : CupertinoIcons.star,
                      size: 20,
                      color: marked.value ? Styles.cYellow : null),
                  onPressed: () async {
                    await Get.find<ContractLogic>()
                        .tapFavoriteCollect('${logic.coin.baseCoin}');
                    marked.value = !marked.value;
                  },
                );
              },
                  RxBool(StoreLogic.to.favoriteContract
                      .contains(logic.coin.baseCoin)))
            ],
          ),
          body: Column(children: [
            TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                controller: _tabController,
                tabs: [
                  Tab(text: S.of(context).derivatives),
                  Tab(text: S.of(context).spot),
                  Tab(text: S.of(context).overview),
                  Tab(text: S.of(context).holding),
                ]),
            Expanded(
                child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: const [
                  AliveWidget(child: CoinDetailContractView()),
                  AliveWidget(child: CoinDetailSpotView()),
                  AliveWidget(child: CoinDetailOverviewView()),
                  AliveWidget(child: CoinDetailHoldView()),
                ]))
          ]),
        ),
        // if (Platform.isIOS)
        //   Positioned.fill(child: Obx(() {
        //     return Visibility(
        //         visible: logic.s1howInterceptor.value,
        //         child: PointerInterceptor(child: const SizedBox()));
        //   }))
      ],
    );
  }
}
