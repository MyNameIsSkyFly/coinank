import 'package:ank_app/modules/market/spot/customize/edit_customize_spot_view.dart';
import 'package:ank_app/modules/market/spot/favorite/f_spot_logic.dart';
import 'package:ank_app/modules/market/utils/text_maps.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../spot_logic.dart';
import 'reorder_spot_logic.dart';

class ReorderSpotPage extends StatelessWidget {
  ReorderSpotPage({super.key});

  static const routeName = '/spotCoinReorder';
  final logic = Get.put(ReorderSpotLogic());
  final pLogic = Get.find<SpotLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).customizeList),
        actions: [
          IconButton(
              onPressed: () => Get.toNamed(EditCustomizeSpotPage.routeName),
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
              title: Text(MarketMaps.spotTextMap(item.key)),
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
              await StoreLogic.to.saveSpotSortOrder(
                  {for (var item in logic.list) item.key: item.value});
              if (Get.isRegistered<SpotLogic>()) {
                var contractCoinLogic = Get.find<SpotLogic>();
                contractCoinLogic.dataSource.getColumns(Get.context!);
                contractCoinLogic.dataSource.buildDataGridRows();
              }
              if (Get.isRegistered<FSpotLogic>()) {
                var contractCoinLogic = Get.find<FSpotLogic>();
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
