import 'dart:async';

import 'package:ank_app/entity/event/theme_event.dart';
import 'package:ank_app/modules/market/spot/spot_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/custom_underliner_tab_indicator.dart';
import 'package:ank_app/widget/market_datagrid_sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

part '_data_grid_view.dart';
part '_f_data_grid_view.dart';

class SpotPage extends StatefulWidget {
  const SpotPage({super.key});

  @override
  State<SpotPage> createState() => _SpotPageState();
}

class _SpotPageState extends State<SpotPage> {
  final logic = Get.put(SpotLogic());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
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
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AliveWidget(
                  child: _FavoriteView(logic: logic),
                ),
                AliveWidget(child: _DataGridView(logic: logic)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteView extends StatefulWidget {
  const _FavoriteView({
    super.key,
    required this.logic,
  });

  final SpotLogic logic;

  @override
  State<_FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<_FavoriteView> {
  @override
  void initState() {
    widget.logic.getMarketDataF();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return IndexedStack(
        index: widget.logic.isLoading.value
            ? 0
            : widget.logic.dataF.isEmpty
                ? 1
                : 2,
        children: [
          Visibility(
              visible: widget.logic.isLoading.value,
              child: const LottieIndicator(margin: EdgeInsets.only(top: 200))),
          _EmptyView(logic: widget.logic),
          EasyRefresh(
            onRefresh: () async => widget.logic.getMarketDataF(),
            child: Obx(() {
              return widget.logic.isLoading.value
                  ? const LottieIndicator(
                      margin: EdgeInsets.only(top: 200),
                    )
                  : _FDataGridView(logic: widget.logic);
            }),
          )
        ],
      );
    });
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({
    required this.logic,
  });

  final SpotLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          itemCount: logic.fixedCoin.length,
          padding: const EdgeInsets.all(15).copyWith(top: 15),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 72,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15),
          itemBuilder: (context, index) {
            return StatefulBuilder(builder: (context, setState) {
              return GestureDetector(
                onTap: () {
                  if (logic.selectedFixedCoin
                      .contains(logic.fixedCoin[index])) {
                    logic.selectedFixedCoin.remove(logic.fixedCoin[index]);
                  } else {
                    logic.selectedFixedCoin.add(logic.fixedCoin[index]);
                  }
                  setState(() {});
                },
                child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(() {
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  logic.fixedCoin[index],
                                  style: Styles.tsBody_16(context).medium,
                                ),
                                Text(
                                  S.of(context).s_swap,
                                  style: Styles.tsSub_12(context),
                                ),
                              ],
                            ),
                          ),
                          if (logic.selectedFixedCoin
                              .contains(logic.fixedCoin[index]))
                            const Icon(CupertinoIcons.checkmark_alt_circle,
                                color: Styles.cMain)
                          else
                            Icon(CupertinoIcons.circle,
                                color: Styles.cSub(context).withOpacity(0.5))
                        ],
                      );
                    })),
              );
            });
          },
        ),
        const Gap(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Obx(() {
            return FilledButton(
                onPressed: logic.selectedFixedCoin.isEmpty
                    ? null
                    : () {
                        if (logic.fetching.value) return;
                        logic.fetching.value = true;
                        logic
                            .saveFixedCoin()
                            .whenComplete(() => logic.fetching.value = false);
                      },
                child: Text(S.of(context).addToFavorite));
          }),
        )
      ],
    );
  }
}
