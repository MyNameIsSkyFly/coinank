import 'dart:async';

import 'package:ank_app/entity/event/theme_event.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/market_datagrid_sizer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'contract_coin_logic.dart';
import 'contract_coin_state.dart';

part '_f_data_grid_view.dart';

class FavoriteCoinPage extends StatefulWidget {
  const FavoriteCoinPage({super.key});

  @override
  State<FavoriteCoinPage> createState() => _FavoriteCoinPageState();
}

class _FavoriteCoinPageState extends State<FavoriteCoinPage> {
  final logic = Get.put(ContractCoinLogic());
  final state = Get.find<ContractCoinLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Obx(() {
          return IndexedStack(
            index: state.isLoadingF.value
                ? 0
                : state.favoriteData.isEmpty
                    ? 1
                    : 2,
            children: [
              Visibility(
                  visible: state.isLoadingF.value,
                  child:
                      const LottieIndicator(margin: EdgeInsets.only(top: 200))),
              _EmptyView(state: state, logic: logic),
              EasyRefresh(
                // scrollBehaviorBuilder: (physics) =>
                //     const ERScrollBehavior(ClampingScrollPhysics()),
                onRefresh: logic.onRefreshF,
                child: Obx(() {
                  return state.isLoadingF.value
                      ? const LottieIndicator(
                          margin: EdgeInsets.only(top: 200),
                        )
                      : _FDataGridView(logic: logic);
                }),
              )
            ],
          );
        })),
      ],
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({
    required this.state,
    required this.logic,
  });

  final ContractCoinState state;
  final ContractCoinLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          itemCount: state.fixedCoin.length,
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
                  if (state.selectedFixedCoin
                      .contains(state.fixedCoin[index])) {
                    state.selectedFixedCoin.remove(state.fixedCoin[index]);
                  } else {
                    state.selectedFixedCoin.add(state.fixedCoin[index]);
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
                                  state.fixedCoin[index],
                                  style: Styles.tsBody_16(context).medium,
                                ),
                                Text(
                                  S.of(context).s_swap,
                                  style: Styles.tsSub_12(context),
                                ),
                              ],
                            ),
                          ),
                          if (state.selectedFixedCoin
                              .contains(state.fixedCoin[index]))
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
                onPressed: state.selectedFixedCoin.isEmpty
                    ? null
                    : () {
                        if (state.fetching.value) return;
                        state.fetching.value = true;
                        logic
                            .saveFixedCoin()
                            .whenComplete(() => state.fetching.value = false);
                      },
                child: Text(S.of(context).addToFavorite));
          }),
        )
      ],
    );
  }
}
