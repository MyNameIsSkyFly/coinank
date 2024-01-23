import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/entity/chart_entity.dart';
import 'package:ank_app/modules/chart/_top_item_detail_page.dart';
import 'package:ank_app/modules/chart/chart_state.dart';
import 'package:ank_app/modules/home/home_search/home_search_view.dart';
import 'package:ank_app/modules/home/liq_main/liq_main_view.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chart_logic.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(ChartLogic());
    final state = Get.find<ChartLogic>().state;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        leadingWidth: 150,
        centerTitle: false,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              S.of(context).s_chart,
              style: Styles.tsBody_20(context)
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        actions: [
          IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => Get.toNamed(HomeSearchPage.routeName),
              icon: Image.asset(
                Assets.imagesIcSearch,
                height: 20,
                width: 20,
                color: Theme.of(context).iconTheme.color,
              )),
          const Gap(10),
        ],
      ),
      body: Obx(() {
        return state.isLoading.value
            ? const LottieIndicator()
            : EasyRefresh(
                onRefresh: logic.onRefresh,
                child: Obx(() {
                  return CustomScrollView(
                    slivers: state.dataMap.isEmpty
                        ? []
                        : [
                            const SliverGap(15),
                            _TopDataView(state: state),
                            Obx(() {
                              return state.recentList.isEmpty
                                  ? const SizedBox().sliverBox
                                  : _ChartItem(
                                      iconName: Assets.chartLeftIconRecent,
                                      title: S.of(context).recentlyUsed,
                                      data: state.recentList,
                                      logic: logic,
                                    );
                            }),
                            _ChartItem(
                                iconName: Assets.chartLeftIconHotData,
                                title: S.current.hotData,
                                data: state.dataMap['hotData'] ?? [],
                                logic: logic),
                            _ChartItem(
                                iconName: Assets.chartLeftIconBtcData,
                                title: S.current.btcData,
                                data: state.dataMap['btcData'] ?? [],
                                logic: logic),
                            _ChartItem(
                                iconName: Assets.chartLeftIconOtherData,
                                title: S.current.otherData,
                                data: state.dataMap['otherData'] ?? [],
                                logic: logic),
                          ],
                  );
                }),
              );
      }),
    );
  }
}

class _TopDataView extends StatelessWidget {
  const _TopDataView({
    required this.state,
  });

  final ChartState state;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 79,
        child: Obx(() {
          return EasyRefresh(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              itemCount: state.topDataList.length,
              itemBuilder: (context, index) {
                final item = state.topDataList.toList()[index];
                String icon = '';
                if (index > state.icoList.length - 1) {
                  icon = state.icoList.last;
                } else {
                  icon = state.icoList[index];
                }
                return GestureDetector(
                  onTap: () {
                    Get.to(() => TopItemDetailPage(
                        title: item.title ?? '', subs: item.subs ?? []));
                  },
                  child: Container(
                    height: 79,
                    width: (MediaQuery.of(context).size.width + 15) / 4 - 10,
                    decoration: BoxDecoration(
                        color: state.topColorList[index],
                        borderRadius: BorderRadius.circular(8)),
                    margin: const EdgeInsets.only(right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          icon,
                          width: 30,
                          height: 30,
                        ),
                        const Gap(5),
                        Text(
                          item.title ?? '',
                          style: Styles.tsBody_12(context).medium,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

class _ChartItem extends StatelessWidget {
  const _ChartItem({
    required this.data,
    required this.title,
    required this.iconName,
    required this.logic,
  });

  final List<ChartEntity> data;
  final String title;
  final String iconName;
  final ChartLogic logic;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 20),
      sliver: SliverMainAxisGroup(
        slivers: [
          Row(
            children: [
              Image.asset(
                iconName,
                width: 20,
                height: 20,
              ),
              const Gap(5),
              Text(
                title,
                style: Styles.tsBody_16m(context),
              ),
            ],
          ).sliverBox,
          const Gap(20).sliverBox,
          SliverGrid.builder(
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisExtent: 75,
              crossAxisSpacing: 20,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  ['liqMapChart', 'liqHeatMapChart'].contains(data[index].key)
                      ? Get.toNamed(LiqMainPage.routeName,
                          arguments: data[index].key == 'liqMapChart' ? 0 : 1)
                      : AppNav.openWebUrl(
                          url: '${Urls.h5Prefix}${data[index].path}',
                          title: data[index].title,
                          showLoading: true,
                        );
                  Future.delayed(const Duration(milliseconds: 300), () {
                    StoreLogic.to
                        .saveRecentChart(data[index])
                        .then((value) => logic.initRecentList());
                  });
                },
                child: Column(
                  children: [
                    ImageUtil.networkImage(
                      'https://cdn01.coinank.com/appicons/${data[index].key}.png',
                      height: 30,
                      width: 30,
                    ),
                    const Gap(5),
                    Text(
                      data[index].title ?? '',
                      style: Styles.tsBody_12(context),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
