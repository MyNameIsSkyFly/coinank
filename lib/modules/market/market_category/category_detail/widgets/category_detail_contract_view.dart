import 'package:ank_app/entity/category_info_item_entity.dart';
import 'package:ank_app/modules/market/contract/contract_coin/contract_coin_logic.dart';
import 'package:ank_app/modules/market/contract/contract_coin/widgets/contract_coin_grid_view.dart';
import 'package:ank_app/modules/market/contract/contract_coin/widgets/customize_filter_header_view.dart';
import 'package:ank_app/modules/market/utils/text_maps.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'category_contract_charts.dart';
import 'category_type_selector.dart';

class CategoryDetailContractView extends StatefulWidget {
  const CategoryDetailContractView({super.key, this.tag});

  final String? tag;

  @override
  State<CategoryDetailContractView> createState() =>
      _CategoryDetailContractViewState();
}

class _CategoryDetailContractViewState extends State<CategoryDetailContractView>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(ContractCoinLogic(isCategory: true), tag: 'category');
  late TabController tabController;
  final selectedIndex = 0.obs;
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void initState() {
    logic.tag.value = widget.tag;
    tabController =
        TabController(length: 2, vsync: this, animationDuration: Duration.zero);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      var indexOfTag = MarketMaps.allCategories
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
                        var item = MarketMaps.allCategories[index];
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
                child: Visibility(
                  visible: selectedIndex.value == 0,
                  child: CustomizeFilterHeaderView(
                      onFinishFilter: () => logic.onRefresh(),
                      isCategory: true),
                ),
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
            children: [
              AliveWidget(
                child: EasyRefresh(
                  footer: const MaterialFooter(),
                  onRefresh: logic.onRefresh,
                  child: ContractCoinGridView(logic: logic),
                ),
              ),
              AliveWidget(child: CategoryContractCharts(tag: widget.tag)),
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

