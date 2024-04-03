import 'package:ank_app/entity/short_rate_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../constants/urls.dart';
import 'long_short_ratio_logic.dart';

class LongShortRatioPage extends StatelessWidget {
  LongShortRatioPage({super.key});

  static const String routeName = '/home/long_short_ratio';

  final logic = Get.find<LongShortRatioLogic>();
  final state = Get.find<LongShortRatioLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitleBar(
        title: S.current.s_buysel_longshort_ratio,
      ),
      body: Obx(() {
        return Column(
          children: [
            if (!state.isLoading.value)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  height: 44,
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          return ScrollablePositionedList.builder(
                            itemScrollController: state.itemScrollController,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            padding: const EdgeInsets.only(left: 15),
                            itemCount: state.headerTitles.length,
                            itemBuilder: (cnt, idx) {
                              String type = state.headerTitles.toList()[idx];
                              return InkWell(
                                onTap: () => logic.tapHeader(type),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: type == state.type.value
                                        ? Styles.cMain.withOpacity(0.1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    type,
                                    style: type == state.type.value
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
              ),
            Expanded(
              child: EasyRefresh(
                onRefresh: () => logic.onRefresh(false),
                child: SingleChildScrollView(
                  physics: state.isLoading.value
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  child: Column(
                    children: [
                      if (state.isLoading.value) const LottieIndicator(),
                      if (!state.isLoading.value)
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(() {
                                    return Text(
                                      '${S.current.s_buysel_longshort_ratio}(${state.type})',
                                      style: Styles.tsBody_14m(context),
                                    );
                                  }),
                                  InkWell(
                                    onTap: () => logic.chooseTime(true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .inputDecorationTheme
                                            .fillColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        children: [
                                          Obx(() {
                                            return Text(
                                              state.longSortTime.value,
                                              style: Styles.tsSub_14m(context),
                                            );
                                          }),
                                          const Gap(10),
                                          Image.asset(
                                            Assets.commonIconArrowDown,
                                            width: 10,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 125,
                                    child: Text(S.current.s_exchange_name,
                                        style: Styles.tsSub_12(context)),
                                  ),
                                  Text(S.current.s_longs,
                                      style: Styles.tsSub_12(context)),
                                  const Spacer(),
                                  Text(S.current.s_shorts,
                                      style: Styles.tsSub_12(context))
                                ],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.dataList.length,
                              itemBuilder: (cnt, idx) {
                                ShortRateEntity item =
                                    state.dataList.toList()[idx];
                                return _DataItem(item: item);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(() {
                                    return Text(
                                      '${S.current.s_takerbuy_longshort_ratio_chart}(${state.type})',
                                      style: Styles.tsBody_14m(context),
                                    );
                                  }),
                                  InkWell(
                                    onTap: () => logic.chooseTime(false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .inputDecorationTheme
                                            .fillColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        children: [
                                          Obx(() {
                                            return Text(
                                              state.webTime.value,
                                              style: Styles.tsSub_14m(context),
                                            );
                                          }),
                                          const Gap(10),
                                          Image.asset(
                                            Assets.commonIconArrowDown,
                                            width: 10,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      Container(
                        height: 280,
                        width: double.infinity,
                        margin: const EdgeInsets.all(15),
                        child: CommonWebView(
                          url: Urls.chartUrl,
                          onWebViewCreated: (controller) =>
                              state.webCtrl = controller,
                          onLoadStop: (controller) =>
                              logic.updateReadyStatus(webReady: true),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _DataItem extends StatelessWidget {
  const _DataItem({required this.item});

  final ShortRateEntity item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          SizedBox(
            width: 125,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageUtil.exchangeImage(
                    item.exchangeName == 'All'
                        ? 'ALL'
                        : item.exchangeName ?? '',
                    size: 24,
                    isCircle: true),
                const Gap(10),
                Text(item.exchangeName ?? '', style: Styles.tsBody_12m(context))
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: ((item.longRatio ?? 0.5) * 1000).toInt(),
                        child: Container(
                          color: Styles.cUp(context),
                          height: 20,
                        ),
                      ),
                      Flexible(
                        flex: ((item.shortRatio ?? 0.5) * 1000).toInt(),
                        child: Container(
                          color: Styles.cDown(context),
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppUtil.getRate(
                                  rate: item.longRatio ?? 0, precision: 2)
                              .substring(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          AppUtil.getRate(
                                  rate: item.shortRatio ?? 0, precision: 2)
                              .substring(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
