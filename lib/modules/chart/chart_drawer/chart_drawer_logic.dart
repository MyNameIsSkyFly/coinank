import 'package:ank_app/entity/chart_left_entity.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

import 'chart_drawer_state.dart';

class ChartDrawerLogic extends GetxController {
  final ChartDrawerState state = ChartDrawerState();

  tapItem(Subs sub) {
    MessageHostApi().toChartWeb(sub.path ?? '', sub.title ?? '');
    Get.find<MainLogic>().state.scaffoldKey.currentState?.closeDrawer();
  }

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
