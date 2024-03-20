import 'package:ank_app/modules/market/contract/contract_coin/contract_coin_logic.dart';
import 'package:ank_app/modules/market/contract/contract_coin/customize/edit_customize_view.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/text_maps.dart';
import '../favorite/f_contract_coin_logic.dart';
import 'reorder_logic.dart';

class ReorderPage extends StatelessWidget {
  ReorderPage({super.key});

  static const routeName = '/contractCoinReorder';
  final logic = Get.put(ReorderLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).customizeList),
        actions: [
          IconButton(
              onPressed: () => Get.toNamed(EditCustomizePage.routeName),
              icon: const ImageIcon(AssetImage(Assets.commonIcEdit), size: 20))
        ],
      ),
      body: Obx(() {
        return ReorderableListView.builder(
          itemCount: logic.list.length,
          proxyDecorator: (child, _, __) => child,
          itemBuilder: (context, index) {
            final item = logic.list[index];
            return ListTile(
              key: ValueKey(item.key),
              title: Text(MarketMaps.contractTextMap(item.key)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              trailing: ReorderableDragStartListener(
                index: index,
                child: Icon(Icons.drag_handle, color: Styles.cSub(context)),
              ),
            );
          },
          onReorder: (int oldIndex, int newIndex) async {
            if (oldIndex < newIndex) newIndex -= 1;
            final item = logic.list.removeAt(oldIndex);
            logic.list.insert(newIndex, item);
            if (!logic.isCategory) {
              await StoreLogic.to.saveContractCoinSortOrder(
                  {for (var item in logic.list) item.key: item.value});
              if (Get.isRegistered<ContractCoinLogic>()) {
                var contractCoinLogic = Get.find<ContractCoinLogic>();
                contractCoinLogic.dataSource.getColumns(Get.context!);
                contractCoinLogic.dataSource.buildDataGridRows();
              }
              if (Get.isRegistered<FContractCoinLogic>()) {
                var contractCoinLogic = Get.find<FContractCoinLogic>();
                contractCoinLogic.dataSource.getColumns(Get.context!);
                contractCoinLogic.dataSource.buildDataGridRows();
              }
            } else {
              //todo category
            }
          },
        );
      }),
    );
  }
}
