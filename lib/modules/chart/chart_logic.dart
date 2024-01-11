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

  void initRecentList() {
    final list = StoreLogic.to.recentCharts;
    state.recentList.assignAll(list);
  }

  Future<void> initTopData() async {
    if (AppConst.networkConnected == false) return;
    final result =
        await Apis().getChartLeftData(locale: AppUtil.shortLanguageName);
    if (result != null) {
      state.topDataList.value = result;
    }
  }

  @override
  void onReady() {
    super.onReady();
    onRefresh();
    initTopData();
    initRecentList();
  }
}
