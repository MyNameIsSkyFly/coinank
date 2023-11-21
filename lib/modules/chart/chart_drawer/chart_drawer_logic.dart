import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

import 'chart_drawer_state.dart';

class ChartDrawerLogic extends GetxController {
  final ChartDrawerState state = ChartDrawerState();

  Future<void> onRefresh() async {
    final result =
        await Apis().getChartLeftData(locale: AppUtil.getLanguageSir());
    if (result != null) {
      state.dataList.value = result;
    }
  }

  @override
  void onReady() {
    super.onReady();
    onRefresh();
  }
}
