import 'package:ank_app/entity/category_info_item_entity.dart';
import 'package:ank_app/modules/market/contract/contract_coin/contract_coin_logic.dart';
import 'package:ank_app/modules/market/contract/contract_coin/widgets/contract_coin_grid_view.dart';
import 'package:ank_app/modules/market/contract/contract_coin/widgets/customize_filter_header_view.dart';
import 'package:ank_app/modules/market/utils/text_maps.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';

class CategoryDetailContractView extends StatefulWidget {
  const CategoryDetailContractView({super.key, this.tag});

  final String? tag;

  @override
  State<CategoryDetailContractView> createState() =>
      _CategoryDetailContractViewState();
}

class _CategoryDetailContractViewState
    extends State<CategoryDetailContractView> {
  final logic = ContractCoinLogic(isCategory: true);

  @override
  void initState() {
    logic.tag = widget.tag;
    logic.onInit();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CategoryDetailContractView oldWidget) {
    if (oldWidget.tag != widget.tag) {
      logic.tag = widget.tag;
      logic.onRefresh();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    logic.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 36,
            child: StatefulBuilder(builder: (context, setState) {
              return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  itemBuilder: (context, index) => Builder(builder: (context) {
                        var item = MarketMaps.allCategories[index];
                        return _tagItem(item, context, setState);
                      }),
                  itemCount: MarketMaps.allCategories.length,
                  scrollDirection: Axis.horizontal);
            })),
        Divider(),
        Row(
          children: [
            Expanded(
              child: CustomizeFilterHeaderView(
                  onFinishFilter: () => logic.onRefresh(), isCategory: true),
            ),
            Container(
                height: 36,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Styles.cLine(context)))),
                child: Container(
                  width: 100,
                  child: Placeholder(),
                )),
          ],
        ),
        Expanded(
          child: EasyRefresh(
            footer: const MaterialFooter(),
            onRefresh: logic.onRefresh,
            child: ContractCoinGridView(logic: logic),
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
          logic.tag = item.type;
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
                color: item.type == logic.tag
                    ? Styles.cBody(context)
                    : Styles.cSub(context)),
          ),
        ),
      ),
    );
  }
}
