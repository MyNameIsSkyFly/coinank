import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

import '_datagrid_source.dart';
import 'spot_logic_mixin.dart';

class SpotLogic extends GetxController with SpotLogicMixin {
  late final gridSource = GridDataSource([]);
  final data = RxList<MarkerTickerEntity>();

  @override
  void onInit() {
    getColumns(Get.context!);
    getMarketData();
    super.onInit();
  }

  Future<void> getMarketData() async {
    final result = await Apis().getSpotAgg(page: 1, size: 500);
    data.assignAll(result?.list ?? []);
    gridSource.items.assignAll(result?.list ?? []);
    gridSource.buildDataGridRows();
    gridSource.updateDataSource();
    columns.refresh();
  }
}
