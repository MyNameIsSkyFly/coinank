import 'package:ank_app/entity/category_info_item_entity.dart';
import 'package:ank_app/modules/market/contract/contract_coin/widgets/customize_filter_header_view.dart';
import 'package:ank_app/modules/market/market_category/category_detail/widgets/category_type_selector.dart';
import 'package:ank_app/modules/market/spot/spot_coin/spot_coin_logic.dart';
import 'package:ank_app/modules/market/spot/widgets/spot_coin_data_grid_view.dart';
import 'package:ank_app/modules/market/utils/text_maps.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/app_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'category_spot_charts.dart';

class CategoryDetailSpotView extends StatefulWidget {
  const CategoryDetailSpotView({super.key, this.tag});

  final String? tag;

  @override
  State<CategoryDetailSpotView> createState() => _CategoryDetailSpotViewState();
}

class _CategoryDetailSpotViewState extends State<CategoryDetailSpotView>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(SpotCoinLogic(isCategory: true), tag: 'category');
  late TabController tabController;
  final selectedIndex = 0.obs;
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void initState() {
    logic.tag.value = widget.tag;
    tabController =
        TabController(length: 2, vsync: this, animationDuration: Duration.zero);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final indexOfTag = MarketMaps.allCategories
          .map((e) => e.type)
          .toList()
          .indexOf(widget.tag);
      itemScrollController.jumpTo(index: indexOfTag);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 36,
            child: StatefulBuilder(builder: (context, setState) {
              return ScrollablePositionedList.builder(
                  itemScrollController: itemScrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  itemBuilder: (context, index) => Builder(builder: (context) {
                        final item = MarketMaps.allCategories[index];
                        return _tagItem(item, context, setState);
                      }),
                  itemCount: MarketMaps.allCategories.length,
                  scrollDirection: Axis.horizontal);
            })),
        const Divider(),
        Obx(() {
          return Row(
            children: [
              Expanded(
                child: CustomizeFilterHeaderView(
                    onFinishFilter: () => logic.onRefresh(showLoading: true),
                    isCategory: true,
                    isSpot: true),
              ),
              CategoryTypeSelector(
                  leftSelected: selectedIndex.value == 0,
                  onTapLeft: () {
                    tabController.animateTo(0);
                    selectedIndex.value = 0;
                  },
                  onTapRight: () {
                    tabController.animateTo(1);
                    selectedIndex.value = 1;
                  }),
            ],
          );
        }),
        Expanded(
          child: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              AliveWidget(
                child: AppRefresh(
                  onRefresh: logic.onRefresh,
                  child: SpotCoinGridView(logic: logic),
                ),
              ),
              AliveWidget(child: CategorySpotCharts(tag: widget.tag)),
            ],
          ),
        ),
      ],
    );
  }

  Center _tagItem(
      CategoryInfoItemEntity item, BuildContext context, StateSetter setState) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          logic.tag.value = item.type;
          await logic.onRefresh(showLoading: true);
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            item.showName ?? '',
            style: TextStyle(
                fontSize: 14,
                fontWeight: Styles.fontMedium,
                color: item.type == logic.tag.value
                    ? Styles.cBody(context)
                    : Styles.cSub(context)),
          ),
        ),
      ),
    );
  }
}
