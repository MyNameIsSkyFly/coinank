import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/entity/chart_entity.dart';
import 'package:ank_app/modules/main/main_logic.dart';
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
      appBar: AppTitleBar(
        title: S.current.s_chart,
        leftWidget: IconButton(
          onPressed: () => Get.find<MainLogic>()
              .state
              .scaffoldKey
              .currentState
              ?.openDrawer(),
          icon: Image.asset(
            Assets.commonIconMenu,
            color: Theme.of(context).iconTheme.color,
            width: 20,
            height: 20,
          ),
        ),
      ),
      body: EasyRefresh(
        onRefresh: logic.onRefresh,
        refreshOnStart: true,
        child: Obx(() {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: CustomScrollView(
              slivers: state.dataMap.isEmpty
                  ? []
                  : [
                      SliverToBoxAdapter(
                        child: _ChartItem(
                          iconName: Assets.chartLeftIconHotData,
                          title: S.current.hotData,
                          data: state.dataMap['hotData'] ?? [],
                        ),
                      ),
                      const SliverToBoxAdapter(child: Gap(20)),
                      SliverToBoxAdapter(
                        child: _ChartItem(
                          iconName: Assets.chartLeftIconBtcData,
                          title: S.current.btcData,
                          data: state.dataMap['btcData'] ?? [],
                        ),
                      ),
                      const SliverToBoxAdapter(child: Gap(20)),
                      SliverToBoxAdapter(
                        child: _ChartItem(
                          iconName: Assets.chartLeftIconOtherData,
                          title: S.current.otherData,
                          data: state.dataMap['otherData'] ?? [],
                        ),
                      ),
                    ],
            ),
          );
        }),
      ),
    );
  }
}

class _ChartItem extends StatelessWidget {
  const _ChartItem({
    super.key,
    required this.data,
    required this.title,
    required this.iconName,
  });

  final List<ChartEntity> data;
  final String title;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
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
        ),
        const Gap(15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(
            data.length,
            (idx) => InkWell(
              onTap: () => AppNav.openWebUrl(
                  url: '${Urls.h5Prefix}${data[idx].path}',
                  title: data[idx].title),
              child: Container(
                height: 46,
                width: AppConst.width / 2 - 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).cardColor,
                ),
                alignment: Alignment.center,
                child: Text(
                  data[idx].title ?? '',
                  style: Styles.tsBody_14(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
