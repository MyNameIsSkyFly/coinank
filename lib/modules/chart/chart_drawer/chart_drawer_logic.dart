import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/entity/chart_left_entity.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

import 'chart_drawer_state.dart';

class ChartDrawerLogic extends GetxController {
  final ChartDrawerState state = ChartDrawerState();

  tapItem(Subs sub) {
    AppNav.openWebUrl(
      url: '${Urls.h5Prefix}${sub.path}',
      title: sub.title,
      showLoading: true,
    );
    Get.find<MainLogic>().state.scaffoldKey.currentState?.closeDrawer();
  }

  Future<void> onRefresh() async {
    if (AppConst.networkConnected == false) return;
    final result =
        await Apis().getChartLeftData(locale: AppUtil.shortLanguageName);
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
