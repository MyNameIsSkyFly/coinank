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
                        child: Text(
                          '热门数据',
                          style: Styles.tsBody_16m(context),
                        ),
                      ),
                      const SliverToBoxAdapter(child: Gap(15)),
                      SliverToBoxAdapter(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                            state.dataMap['hotData']?.length ?? 0,
                            (idx) => InkWell(
                              child: Container(
                                height: 46,
                                width: AppConst.width / 2 - 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color:
                                          Theme.of(context).dividerTheme.color!,
                                      width: 1),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  state.dataMap['hotData']?[idx].title ?? '',
                                  style: Styles.tsBody_14(context),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: Gap(20)),
                      SliverToBoxAdapter(
                        child: Text(
                          'BTC数据',
                          style: Styles.tsBody_16m(context),
                        ),
                      ),
                      const SliverToBoxAdapter(child: Gap(15)),
                      SliverToBoxAdapter(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                            state.dataMap['btcData']?.length ?? 0,
                            (idx) => InkWell(
                              child: Container(
                                height: 46,
                                width: AppConst.width / 2 - 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color:
                                          Theme.of(context).dividerTheme.color!,
                                      width: 1),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  state.dataMap['btcData']?[idx].title ?? '',
                                  style: Styles.tsBody_14(context),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: Gap(20)),
                      SliverToBoxAdapter(
                        child: Text(
                          '其他数据',
                          style: Styles.tsBody_16m(context),
                        ),
                      ),
                      const SliverToBoxAdapter(child: Gap(15)),
                      SliverToBoxAdapter(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                            state.dataMap['otherData']?.length ?? 0,
                            (idx) => InkWell(
                              child: Container(
                                height: 46,
                                width: AppConst.width / 2 - 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color:
                                          Theme.of(context).dividerTheme.color!,
                                      width: 1),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  state.dataMap['otherData']?[idx].title ?? '',
                                  style: Styles.tsBody_14(context),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
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

