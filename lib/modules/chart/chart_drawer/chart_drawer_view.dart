import 'package:ank_app/entity/chart_left_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'chart_drawer_logic.dart';

class ChartDrawerPage extends StatelessWidget {
  ChartDrawerPage({super.key});

  final logic = Get.put(ChartDrawerLogic());
  final state = Get.find<ChartDrawerLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(AppConst.statusBarHeight),
            SizedBox(
              height: kToolbarHeight,
              child: IconButton(
                onPressed: Get.back,
                icon: Image.asset(
                  Assets.commonIconArrowLeft,
                  width: 20,
                  height: 20,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                itemCount: state.dataList.length,
                itemBuilder: (cnt, idx) {
                  ChartLeftEntity item = state.dataList.toList()[idx];
                  String icon = '';
                  if (idx > state.icoList.length - 1) {
                    icon = state.icoList.last;
                  } else {
                    icon = state.icoList[idx];
                  }
                  final expandableController = ExpandableController();
                  return ExpandablePanel(
                    controller: expandableController,
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      hasIcon: false,
                    ),
                    header: Container(
                      height: 50,
                      padding: const EdgeInsets.only(left: 15, right: 5),
                      child: Row(
                        children: [
                          Image.asset(
                            icon,
                            width: 20,
                            height: 20,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          const Gap(10),
                          Text(
                            item.title ?? '',
                            style: Styles.tsBody_16(context),
                          ),
                          const Spacer(),
                          ExpandableIcon(
                            theme: ExpandableThemeData(
                              expandIcon: Icons.keyboard_arrow_right_rounded,
                              collapseIcon: Icons.keyboard_arrow_down_rounded,
                              iconSize: 20,
                              iconRotationAngle: math.pi / 4,
                              hasIcon: false,
                              iconColor: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    collapsed: Container(),
                    expanded: Container(
                      color: Theme.of(context).cardColor,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: item.subs?.length ?? 0,
                        shrinkWrap: true,
                        itemBuilder: (cnt, index) {
                          Subs sub = item.subs![index];
                          return sub.subs == null
                              ? InkWell(
                                  onTap: () => logic.tapItem(sub),
                                  child: Container(
                                    height: 48,
                                    padding: const EdgeInsets.only(left: 45),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      sub.title ?? '',
                                      style: Styles.tsSub_14(context),
                                    ),
                                  ),
                                )
                              : _lastItem(sub, context);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _lastItem(Subs sub, BuildContext context) {
    final expandable = ExpandableController();

    return ExpandablePanel(
      controller: expandable,
      theme: const ExpandableThemeData(
        headerAlignment: ExpandablePanelHeaderAlignment.center,
        hasIcon: false,
      ),
      header: Container(
        height: 48,
        padding: const EdgeInsets.only(left: 45, right: 5),
        child: Row(
          children: [
            Text(
              sub.title ?? '',
              style: Styles.tsSub_14(context),
            ),
            const Spacer(),
            ExpandableIcon(
              theme: ExpandableThemeData(
                expandIcon: Icons.keyboard_arrow_right_rounded,
                collapseIcon: Icons.keyboard_arrow_down_rounded,
                iconSize: 20,
                iconRotationAngle: math.pi / 4,
                hasIcon: false,
                iconColor: Theme.of(context).iconTheme.color,
              ),
            ),
          ],
        ),
      ),
      collapsed: Container(),
      expanded: Container(
        color: Theme.of(context).cardColor,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sub.subs?.length ?? 0,
          shrinkWrap: true,
          itemExtent: 48,
          itemBuilder: (cnt, index) {
            Subs last = sub.subs![index];
            return InkWell(
              onTap: () => logic.tapItem(last),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 30),
                title: Text(
                  last.title ?? '',
                  style: Styles.tsSub_12(context),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
