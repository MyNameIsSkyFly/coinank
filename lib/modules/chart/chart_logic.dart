import 'dart:async';

import 'package:ank_app/entity/chart_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

import 'chart_state.dart';

class ChartLogic extends GetxController {
  final ChartState state = ChartState();

  StreamSubscription? appThemeSubscription;

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
    initRecentList();
  }

  void initRecentList() {
    final list = StoreLogic.to.recentCharts;
    final result = <ChartEntity>[];
    final allData = [
      ...state.dataMap['hotData'] ?? [],
      ...state.dataMap['btcData'] ?? [],
      ...state.dataMap['otherData'] ?? [],
    ];
    final keys = allData.map((e) => e.key).toList();
    for (var element in list) {
      if (keys.contains(element.key)) {
        element.title = allData.firstWhere((e) => e.key == element.key).title;
        result.add(element);
      }
    }
    state.recentList.assignAll(result);
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
