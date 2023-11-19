import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/custom_bottom_sheet/custom_bottom_sheet_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'funding_rate_state.dart';

class FundingRateLogic extends GetxController {
  final FundingRateState state = FundingRateState();

  @override
  void onReady() {
    super.onReady();
    onRefresh();
  }

  @override
  void onInit() {
    super.onInit();
    state.titleController.addListener(_updateContent);
    state.contentController.addListener(_updateTitle);
  }

  void tapHide(bool v) {
    if (state.isHide.value != !v) {
      state.isHide.value = !v;
    }
  }

  void tapCmap(bool v) {
    if (state.isCmap.value != !v) {
      state.isCmap.value = !v;
      state.topList.value = !state.isCmap.value
          ? ['Binance', 'Okex', 'Bybit', 'Bitget', 'Gate', 'dYdX', 'Huobi']
          : ['Binance', 'Okex', 'Bybit', 'Bitget', 'Gate', 'Bitmex', 'Huobi'];
    }
  }

  Future<void> tapTime() async {
    String time = state.time.isEmpty ? S.current.s_current : state.time.value;
    Map<String, String> timeMap = {
      S.current.s_current: 'current',
      S.current.s_day: 'day',
      S.current.s_week: 'week',
      S.current.s_month: 'month',
      S.current.s_year: 'year',
    };
    final result = await Get.bottomSheet(
      CustomBottomSheetPage(),
      isScrollControlled: true,
      isDismissible: true,
      settings: RouteSettings(
        arguments: {
          'title': '选择时间',
          'list': timeMap.keys.toList(),
          'current': time,
        },
      ),
    );
    if (result != null) {
      if (time == result) return;
      state.time.value = result as String;
      state.timeType = timeMap[state.time.value] as String;
      onRefresh(showLoading: true);
    }
  }

  void _updateTitle() {
    if (state.titleController.offset != state.contentController.offset) {
      state.titleController.jumpTo(state.contentController.offset);
    }
  }

  void _updateContent() {
    if (state.contentController.offset != state.titleController.offset) {
      state.contentController.jumpTo(state.titleController.offset);
    }
  }

  Future<void> onRefresh({bool showLoading = false}) async {
    if(showLoading){
      Loading.show();
    }
    final data = await Apis().getMarketFundingRateData(type: state.timeType);
    Loading.dismiss();
    if (data != null) {
      state.contentDataList.value = data;
    }
  }

  @override
  void onClose() {
    state.titleController.removeListener(_updateContent);
    state.contentController.removeListener(_updateTitle);
    super.onClose();
  }
}
