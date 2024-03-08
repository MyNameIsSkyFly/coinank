import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'funding_rate_logic.dart';

part '_data_grid_view.dart';

class FundingRatePage extends StatelessWidget {
  const FundingRatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(FundingRateLogic());
    final state = Get.find<FundingRateLogic>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 47,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: () async {
                  if (!StoreLogic.isLogin) {
                    AppNav.toLogin();
                    return;
                  }
                  logic.isFavorite.toggle();
                  await logic.onRefresh(showLoading: true);
                },
                child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Obx(() {
                        return ImageIcon(
                            AssetImage(logic.isFavorite.value
                                ? Assets.commonIconStarFill
                                : Assets.commonIconStar),
                            size: 17,
                            color:
                                logic.isFavorite.value ? Styles.cYellow : null);
                      }),
                    )),
              ),
              const Gap(10),
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
              InkWell(
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
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 15,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ],
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
        Obx(() {
          return state.isLoading.value
              ? const LottieIndicator(
                  margin: EdgeInsets.only(top: 150),
                )
              : Expanded(
                  child: EasyRefresh(
                    onRefresh: () => logic.onRefresh(),
                    child: _DataGridView(logic: logic),
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
