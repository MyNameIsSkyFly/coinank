import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/app_refresh.dart';
import 'package:ank_app/widget/visibility_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/contract_coin_grid_view.dart';
import '../widgets/customize_filter_header_view.dart';
import 'contract_coin_logic_f.dart';

class ContractCoinPageF extends StatefulWidget {
  const ContractCoinPageF({super.key});

  @override
  State<ContractCoinPageF> createState() => _ContractCoinPageFState();
}

class _ContractCoinPageFState extends VisibilityState<ContractCoinPageF> {
  final logic = Get.put(ContractCoinLogicF());

  @override
  Widget builder(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Obx(() {
          return IndexedStack(
            index: logic.isLoading.value
                ? 0
                : logic.data.isEmpty
                    ? StoreLogic().contractCoinFilter == null
                        ? 1
                        : 2
                    : 2,
            children: [
              Visibility(
                  visible: logic.isLoading.value,
                  child:
                      const LottieIndicator(margin: EdgeInsets.only(top: 200))),
              _FixedCoins(logic: logic),
              Stack(
                children: [
                  Column(
                    children: [
                      CustomizeFilterHeaderView(
                          onFinishFilter: () =>
                              logic.onRefresh(showLoading: true)),
                      Expanded(
                        child: AppRefresh(
                          onRefresh: () async => logic.onRefresh(),
                          child: ContractCoinGridView(logic: logic),
                        ),
                      ),
                    ],
                  ),
                  if (logic.data.isEmpty)
                    Center(
                        child: Image.asset(Assets.commonIcEmptyBox,
                            height: 150, width: 150)),
                ],
              )
            ],
          );
        })),
      ],
    );
  }

  @override
  void onVisibleAgain() {
    logic.stopTimer();
    logic.onRefresh().then((value) => logic.startTimer());
  }
}

class _FixedCoins extends StatelessWidget {
  const _FixedCoins({
    required this.logic,
  });

  final ContractCoinLogicF logic;

  @override
  Widget build(BuildContext context) {
    return AppRefresh(
      onRefresh: () async => logic.onRefresh(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
                                child: Text(
                                  logic.fixedCoin[index],
                                  style: Styles.tsBody_16(context).medium,
                                ),
                              ),
                              if (logic.selectedFixedCoin
                                  .contains(logic.fixedCoin[index]))
                                const Icon(CupertinoIcons.checkmark_alt_circle,
                                    color: Styles.cMain)
                              else
                                Icon(CupertinoIcons.circle,
                                    color:
                                        Styles.cSub(context).withOpacity(0.5))
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
                            logic.saveFixedCoin().whenComplete(
                                () => logic.fetching.value = false);
                          },
                    child: Text(S.of(context).addToFavorite));
              }),
            )
          ],
        ),
      ),
    );
  }
}
