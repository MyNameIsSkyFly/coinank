import 'dart:math';

import 'package:ank_app/entity/marker_funding_rate_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'funding_rate_logic.dart';

class FundingRatePage extends StatelessWidget {
  const FundingRatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(FundingRateLogic());
    final state = Get.find<FundingRateLogic>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Row(
            children: [
              Obx(() {
                return _Segment(
                  titles: [S.current.s_show_pre_fr, S.current.s_hide],
                  isFirst: !state.isHide.value,
                  onTap: (v) => logic.tapHide(v),
                );
              }),
              const Gap(10),
              Obx(() {
                return _Segment(
                  titles: [S.current.s_u_fr, S.current.s_coin_fr],
                  isFirst: !state.isCmap.value,
                  onTap: (v) => logic.tapCmap(v),
                );
              }),
              const Gap(10),
              Expanded(
                child: InkWell(
                  onTap: () => logic.tapTime(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 32,
                    decoration: BoxDecoration(
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Obx(() {
                          return Text(
                            state.time.isEmpty
                                ? S.current.s_current
                                : state.time.value,
                            style: Styles.tsBody_14m(context),
                          );
                        }),
                        const Gap(5),
                        const Spacer(),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 15,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          return AnimatedSize(
            duration: const Duration(milliseconds: 100),
            alignment: Alignment.topCenter,
            child: InkWell(
              onTap: () => logic.tapSearch(),
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                height: state.isScrollDown.value ? 32 : 0,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      Assets.commonIconSearch,
                      width: 16,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    const Gap(10),
                    Text(
                      S.current.s_search,
                      style: Styles.tsSub_12(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15),
              width: 100,
              child: Text(
                'Coin',
                style: Styles.tsSub_14(context),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 48,
                child: Obx(() {
                  return ListView.builder(
                      controller: state.titleController,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: state.topList.length,
                      itemBuilder: (cnt, idx) {
                        return SizedBox(
                          width: 100,
                          child: Obx(() {
                            return SortWithArrow(
                              icon: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/platform/${state.topList[idx].toLowerCase()}.png',
                                    width: 15,
                                  ),
                                ),
                              ),
                              title: state.topList.toList()[idx],
                              style: Styles.tsBody_12m(context),
                              status: state.topStatusList.toList()[idx],
                              onTap: () => logic.tapSort(idx),
                            );
                          }),
                        );
                      });
                }),
              ),
            ),
          ],
        ),
        Obx(() {
          return state.isLoading.value
              ? const LottieIndicator(
                  margin: EdgeInsets.only(top: 150),
                )
              : Expanded(
                  child: EasyRefresh(
                    onRefresh: () => logic.onRefresh(),
                    child: Obx(() {
                      return SingleChildScrollView(
                        controller: state.scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  width: 100,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemExtent: state.isHide.value ? 48 : 58,
                                    itemCount: state.contentDataList.length,
                                    itemBuilder: (cnt, idx) {
                                      MarkerFundingRateEntity item =
                                          state.contentDataList.toList()[idx];
                                      return Row(
                                        children: [
                                          ClipOval(
                                            child: ImageUtil.networkImage(
                                              AppConst.imageHost(
                                                  item.symbol ?? ''),
                                              width: 24,
                                              height: 24,
                                            ),
                                          ),
                                          const Gap(10),
                                          Expanded(
                                            child: Text(
                                              item.symbol ?? '',
                                              style: Styles.tsBody_14m(context),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: max(
                                        state.contentDataList.length * 48, 480),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      controller: state.contentController,
                                      scrollDirection: Axis.horizontal,
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: state.topList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (cnt, index) {
                                        return SizedBox(
                                          width: 100,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemExtent:
                                                state.isHide.value ? 48 : 58,
                                            itemCount:
                                                state.contentDataList.length,
                                            itemBuilder: (cnt, idx) {
                                              MarkerFundingRateEntity item =
                                                  state.contentDataList
                                                      .toList()[idx];
                                              String mapKey =
                                                  state.topList.toList()[index];
                                              return Obx(() {
                                                Exchange? exchangeItem =
                                                    item.cmap![mapKey];
                                                if (!state.isCmap.value) {
                                                  exchangeItem =
                                                      item.umap![mapKey];
                                                }
                                                return Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        AppUtil.getRate(
                                                            rate: exchangeItem
                                                                ?.fundingRate,
                                                            precision: 4,
                                                            showAdd: false),
                                                        style: Styles.tsBody_12m(
                                                                context)
                                                            .copyWith(
                                                          color: AppUtil
                                                              .getColorWithFundRate(
                                                                  exchangeItem
                                                                      ?.fundingRate),
                                                        ),
                                                      ),
                                                      if (!state.isHide.value)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 4),
                                                          child: Text(
                                                            AppUtil.getRate(
                                                                rate: exchangeItem
                                                                    ?.estimatedRate,
                                                                precision: 4,
                                                                showAdd: false),
                                                            style: Styles
                                                                    .tsBody_12m(
                                                                        context)
                                                                .copyWith(
                                                              color: AppUtil
                                                                  .getColorWithFundRate(
                                                                      exchangeItem
                                                                          ?.estimatedRate),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                );
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                );
        }),
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.isFirst,
    required this.titles,
    this.onTap,
  });

  final bool isFirst;
  final List<String> titles;
  final Function(bool)? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 32,
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onTap != null ? () => onTap!(true) : null,
            child: Text(
              titles.first,
              style: isFirst
                  ? Styles.tsBody_14m(context)
                  : Styles.tsSub_14(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              '/',
              style: Styles.tsSub_12(context),
            ),
          ),
          InkWell(
            onTap: onTap != null ? () => onTap!(false) : null,
            child: Text(
              titles.last,
              style: !isFirst
                  ? Styles.tsBody_14m(context)
                  : Styles.tsSub_14(context),
            ),
          ),
        ],
      ),
    );
  }
}
