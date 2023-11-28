import 'dart:math';

import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'price_change_logic.dart';

class PriceChangePage extends StatelessWidget {
  PriceChangePage({super.key});

  static const String priceChange = '/home/priceChange';

  final logic = Get.find<PriceChangeLogic>();
  final state = Get.find<PriceChangeLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitleBar(
        title: state.isPrice ? S.current.s_price_chg : S.current.s_oi_chg,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                width: 100,
                child: Text(
                  'Coin',
                  style: Styles.tsSub_14(context),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ListView.builder(
                      controller: state.titleController,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: state.topList.length,
                      itemBuilder: (cnt, idx) {
                        return Obx(() {
                          return SizedBox(
                            width: 105,
                            child: SortWithArrow(
                              title: state.topList.toList()[idx],
                              style: Styles.tsBody_12(context),
                              status: state.statusList.toList()[idx],
                              onTap: () => logic.tapSort(idx),
                            ),
                          );
                        });
                      }),
                ),
              ),
            ],
          ),
          Expanded(
            child: EasyRefresh(
              onRefresh: () => logic.onRefresh(),
              refreshOnStart: true,
              child: Obx(() {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            width: 100,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemExtent: 48,
                              itemCount: state.contentDataList.length,
                              itemBuilder: (cnt, idx) {
                                MarkerTickerEntity item =
                                    state.contentDataList.toList()[idx];
                                return InkWell(
                                  onTap: () => logic.tapItem(item),
                                  child: Row(
                                    children: [
                                      ClipOval(
                                        child: ImageUtil.networkImage(
                                          item.coinImage ?? '',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      const Gap(10),
                                      Expanded(
                                        child: Text(
                                          item.baseCoin ?? '',
                                          style: Styles.tsBody_12m(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height:
                                  max(state.contentDataList.length * 48, 480),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                controller: state.contentController,
                                scrollDirection: Axis.horizontal,
                                physics: const ClampingScrollPhysics(),
                                itemCount: state.topList.length,
                                shrinkWrap: true,
                                itemBuilder: (cnt, index) {
                                  return _DataItem(logic: logic, index: index);
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
          ),
        ],
      ),
    );
  }
}

class _DataItem extends StatelessWidget {
  const _DataItem({
    super.key,
    required this.logic,
    required this.index,
  });

  final PriceChangeLogic logic;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 105,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemExtent: 48,
        itemCount: logic.state.contentDataList.length,
        itemBuilder: (cnt, idx) {
          MarkerTickerEntity item = logic.state.contentDataList.toList()[idx];
          List<String> textList = ['${item.price}'];
          List<Color> colorList = [
            Theme.of(context).textTheme.bodyMedium!.color!,
          ];
          if (logic.state.isPrice) {
            textList.addAll([
              AppUtil.getRate(
                  rate: item.priceChangeM5, precision: 2, mul: false),
              AppUtil.getRate(
                  rate: item.priceChangeM15, precision: 2, mul: false),
              AppUtil.getRate(
                  rate: item.priceChangeM30, precision: 2, mul: false),
              AppUtil.getRate(
                  rate: item.priceChangeH1, precision: 2, mul: false),
              AppUtil.getRate(
                  rate: item.priceChangeH4, precision: 2, mul: false),
              AppUtil.getRate(
                  rate: item.priceChangeH24, precision: 2, mul: false),
            ]);
            colorList.addAll([
              (item.priceChangeM5 ?? 0) >= 0
                  ? Styles.cUp(context)
                  : Styles.cDown(context),
              (item.priceChangeM15 ?? 0) >= 0
                  ? Styles.cUp(context)
                  : Styles.cDown(context),
              (item.priceChangeM30 ?? 0) >= 0
                  ? Styles.cUp(context)
                  : Styles.cDown(context),
              (item.priceChangeH1 ?? 0) >= 0
                  ? Styles.cUp(context)
                  : Styles.cDown(context),
              (item.priceChangeH4 ?? 0) >= 0
                  ? Styles.cUp(context)
                  : Styles.cDown(context),
              (item.priceChangeH24 ?? 0) >= 0
                  ? Styles.cUp(context)
                  : Styles.cDown(context),
            ]);
          } else {
            textList.addAll([
              AppUtil.getLargeFormatString('${item.openInterest ?? 0}'),
              AppUtil.getRate(rate: item.openInterestCh1, precision: 2),
              AppUtil.getRate(rate: item.openInterestCh4, precision: 2),
              AppUtil.getRate(rate: item.openInterestCh24, precision: 2),
            ]);
            colorList.addAll([
              Theme.of(context).textTheme.bodyMedium!.color!,
              (item.openInterestCh1 ?? 0) >= 0
                  ? Styles.cUp(context)
                  : Styles.cDown(context),
              (item.openInterestCh4 ?? 0) >= 0
                  ? Styles.cUp(context)
                  : Styles.cDown(context),
              (item.openInterestCh24 ?? 0) >= 0
                  ? Styles.cUp(context)
                  : Styles.cDown(context),
            ]);
          }
          return InkWell(
            onTap: () => logic.tapItem(item),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                textList[index],
                style:
                    Styles.tsBody_12(context).copyWith(color: colorList[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
