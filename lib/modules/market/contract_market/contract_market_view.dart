import 'package:ank_app/entity/contract_market_entity.dart';
import 'package:ank_app/modules/market/contract/contract_logic.dart';
import 'package:flutter/material.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'contract_market_logic.dart';

class ContractMarketPage extends StatelessWidget {
  const ContractMarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(ContractMarketLogic());
    final state = Get.find<ContractMarketLogic>().state;
    return Obx(() {
      return state.isLoading.value
          ? const LottieIndicator()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(5),
                SizedBox(
                  height: 44,
                  child: Row(
                    children: [
                      Expanded(
                        child: GetBuilder<ContractMarketLogic>(
                            id: 'header',
                            builder: (_) {
                              return ScrollablePositionedList.builder(
                                itemScrollController:
                                    state.itemScrollController,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const ClampingScrollPhysics(),
                                padding: const EdgeInsets.only(left: 15),
                                itemCount: state.headerTitles?.length ?? 0,
                                itemBuilder: (cnt, idx) {
                                  String type = state.headerTitles![idx];
                                  return InkWell(
                                    onTap: () => logic.tapHeader(type),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: type == state.type
                                            ? Styles.cMain.withOpacity(0.1)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        type,
                                        style: type == state.type
                                            ? Styles.tsMain_14m
                                            : Styles.tsSub_14(context),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                      ),
                      InkWell(
                        onTap: () => logic.toSearch(),
                        child: Container(
                          padding: const EdgeInsets.only(left: 8),
                          color: Theme.of(context).colorScheme.tertiary,
                          width: 39,
                          height: 24,
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            Assets.commonIconSearch,
                            width: 16,
                            height: 16,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: GetBuilder<ContractMarketLogic>(
                      id: 'sort',
                      builder: (_) {
                        return Row(
                          children: [
                            Text(
                              'Coin',
                              style: Styles.tsSub_14(context),
                            ),
                            const Spacer(),
                            SortWithArrow(
                              title: S.current.s_price,
                              status: state.priceSort,
                              onTap: () => logic.tapSort(SortType.price),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child:
                                  Text('/', style: Styles.tsSub_12m(context)),
                            ),
                            SortWithArrow(
                              title: S.current.s_24h_turnover,
                              status: state.volSort,
                              onTap: () => logic.tapSort(SortType.volH24),
                            ),
                            SizedBox(
                              width: 130,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SortWithArrow(
                                    title: S.current.s_oi,
                                    status: state.oiSort,
                                    onTap: () =>
                                        logic.tapSort(SortType.openInterest),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: Text('/',
                                        style: Styles.tsSub_12m(context)),
                                  ),
                                  SortWithArrow(
                                    title: S.current.s_funding_rate,
                                    status: state.rateSort,
                                    onTap: () =>
                                        logic.tapSort(SortType.fundingRate),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                ),
                GetBuilder<ContractMarketLogic>(
                    id: 'content',
                    builder: (_) {
                      return Expanded(
                        child: EasyRefresh(
                          onRefresh: logic.getAllData,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                            itemCount: state.dataList?.length ?? 0,
                            itemBuilder: (cnt, idx) {
                              ContractMarketEntity item = state.dataList![idx];
                              return InkWell(
                                onTap: () => AppUtil.toKLine(
                                    item.exchangeName ?? '',
                                    item.symbol ?? '',
                                    item.baseCoin ?? '',
                                    'SWAP'),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      ClipOval(
                                        child: Image.asset(
                                          'assets/images/platform/${item.exchangeName?.toLowerCase()}.png',
                                          width: 24,
                                        ),
                                      ),
                                      const Gap(10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.exchangeName ?? '',
                                            style: Styles.tsBody_12m(context),
                                          ),
                                          const Gap(5),
                                          Text(
                                            item.symbol ?? '',
                                            style: Styles.tsSub_10(context)
                                                .copyWith(fontSize: 9),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '\$${item.lastPrice ?? 0}',
                                            style: Styles.tsBody_12(context),
                                          ),
                                          const Gap(3),
                                          Text(
                                            '\$${AppUtil.getLargeFormatString('${item.turnover24h ?? 0}')}',
                                            style: Styles.tsSub_12(context),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 130,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '\$${AppUtil.getLargeFormatString('${item.oiUSD ?? 0}')}',
                                              style: Styles.tsBody_12(context),
                                            ),
                                            const Gap(3),
                                            Text(
                                              '${((item.fundingRate ?? 0) * 100).toStringAsFixed(4)}%',
                                              style: Styles.tsSub_12(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
              ],
            );
    });
  }
}
