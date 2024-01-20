import 'dart:math' as math;

import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/entity/chart_left_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class TopItemDetailPage extends StatelessWidget {
  const TopItemDetailPage({super.key, required this.title, required this.subs});

  final String title;
  final List<ChartSubItem> subs;

  tapItem(ChartSubItem sub) {
    AppNav.openWebUrl(
      url: '${Urls.h5Prefix}${sub.path}',
      title: sub.title,
      showLoading: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitleBar(title: title),
      body: ListView.builder(
        itemCount: subs.length,
        itemBuilder: (context, index) {
          final item = subs[index];

          final expandableController = ExpandableController();
          if (item.subs == null) {
            return GestureDetector(
              onTap: () => tapItem(item),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                margin: const EdgeInsets.symmetric(horizontal: 15)
                    .copyWith(top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).cardColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      )
                    ]),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(item.title ?? '',
                            style: Styles.tsBody_14(context))),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.black87,
                      size: 18,
                    )
                  ],
                ),
              ),
            );
          }
          return Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).cardColor,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  )
                ]),
            child: ExpandablePanel(
              controller: expandableController,
              theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                hasIcon: false,
              ),
              header: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5)
                    .copyWith(right: 0),
                child: Row(
                  children: [
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
                    final sub = item.subs![index];
                    return sub.subs == null
                        ? InkWell(
                            onTap: () => tapItem(sub),
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.only(left: 15),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      sub.title ?? '',
                                      style: Styles.tsSub_14(context),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.black87,
                                    size: 18,
                                  ),
                                  const Gap(8),
                                ],
                              ),
                            ),
                          )
                        : _lastItem(sub, context);
                  },
                ),
              ),
            ),
          );
          // return ListTile(title: Text(item.title??''),);
        },
      ),
    );
  }

  Widget _lastItem(ChartSubItem sub, BuildContext context) {
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
            final last = sub.subs![index];
            return InkWell(
              onTap: () => tapItem(last),
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
