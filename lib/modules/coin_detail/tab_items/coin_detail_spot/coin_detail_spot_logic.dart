import 'dart:async';

import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

import '../../coin_detail_logic.dart';
import '_datagrid_source.dart';

class CoinDetailSpotLogic extends GetxController {
  final detailLogic = Get.find<CoinDetailLogic>();
  late final gridSource = GridDataSource([], baseCoin);

  String get baseCoin => detailLogic.coin.baseCoin ?? '';
  Timer? _timer;
  @override
  void onReady() {
    getGridData();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!Get.find<MainLogic>().state.appVisible ||
          Get.find<CoinDetailLogic>().tabController.index != 1) return;
      getGridData();
    });
    super.onReady();
  }

  void getGridData() {
    Apis().getSpotTickers(baseCoin).then((value) {
      gridSource.items.clear();
      gridSource.items.addAll(value ?? []);
      gridSource.buildDataGridRows();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
