import 'package:ank_app/entity/chart_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

import 'chart_state.dart';

class ChartLogic extends GetxController {
  final ChartState state = ChartState();

  Future<void> onRefresh() async {
    if (AppConst.networkConnected == false) return;
    Map<String, List<ChartEntity>> dataMap = {
      'hotData': [],
      'btcData': [],
      'otherData': [],
    };
    final result = await Apis().getChartData(locale: AppUtil.shortLanguageName);
    state.isLoading.value = false;
    result?.forEach((element) {
      dataMap[element.groupName]!.add(element);
    });
    state.dataMap.value = dataMap;
  }

  @override
  void onReady() {
    super.onReady();
    onRefresh();
  }
}
