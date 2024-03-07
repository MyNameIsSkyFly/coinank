import 'dart:async';

import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/modules/market/contract/contract_logic.dart';
import 'package:ank_app/modules/market/contract/funding_rate_search/funding_rate_search_view.dart';
import 'package:ank_app/modules/market/market_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/custom_bottom_sheet/custom_bottom_sheet_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '_datagrid_source.dart';
import 'funding_rate_state.dart';

class FundingRateLogic extends FullLifeCycleController with FullLifeCycleMixin {
  final FundingRateState state = FundingRateState();
  late final gridSource = GridDataSource([]);
  final isFavorite = false.obs;

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
      state.topStatusList.value =
          List.generate(state.topList.length, (index) => SortStatus.normal);
      gridSource.buildDataGridRows();
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
      const CustomBottomSheetPage(),
      isScrollControlled: true,
      isDismissible: true,
      settings: RouteSettings(
        arguments: {
          'title': S.current.s_choose_time,
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

  tapSearch() async {
    final result = await showModalBottomSheet(
      isScrollControlled: true,
      context: Get.context!,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (cnt) {
        return const FundingRateSearchPage();
      },
      routeSettings: RouteSettings(arguments: {
        'select': List<String>.from(state.searchList),
        'data': state.contentOriginalDataList!.map((e) => e.symbol!).toList()
      }),
    );
    if (result != null) {
      state.searchList = result as List<String>;
      // sort(state.topList.toList()[state.sortIndex],
      //     state.topStatusList.toList()[state.sortIndex]);
      gridSource.buildDataGridRows();
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
    if (showLoading) {
      Loading.show();
    }
    state.isRefresh = true;
    final data = await Apis()
        .getMarketFundingRateData(
            type: state.timeType, isFollow: isFavorite.value)
        .whenComplete(() => Loading.dismiss());

    if (state.isLoading.value) {
      state.isLoading.value = false;
    }
    state.isRefresh = false;
    if (data != null) {
      gridSource.items.assignAll(data);
      gridSource.buildDataGridRows();
      state.contentOriginalDataList = data;
      // sort(state.topList.toList()[state.sortIndex],
      //     state.topStatusList.toList()[state.sortIndex]);
    }
  }

  _startTimer() async {
    state.pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (kDebugMode) return;
      if (Get.find<MarketLogic>().tabCtrl.index != 0) return;
      if (Get.find<MainLogic>().state.selectedIndex.value == 1 &&
          !state.isRefresh &&
          Get.find<ContractLogic>().state.tabController?.index == 5 &&
          state.appVisible) {
        onRefresh();
      }
    });
  }

  _scrollListener() {
    double offset = state.scrollController.offset;
    state.isScrollDown.value = offset <= 0 || state.offset - offset > 0;
    state.offset = offset;
  }

  @override
  void onReady() {
    super.onReady();
    onRefresh();
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    state.scrollController.addListener(_scrollListener);
    state.titleController.addListener(_updateContent);
    state.contentController.addListener(_updateTitle);
    _startTimer();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    state.scrollController.removeListener(_scrollListener);
    state.titleController.removeListener(_updateContent);
    state.contentController.removeListener(_updateTitle);
    state.pollingTimer?.cancel();
    state.pollingTimer = null;
    super.onClose();
  }

  @override
  void onDetached() {}

  @override
  void onHidden() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {
    //应用程序不可见，后台
    state.appVisible = false;
  }

  @override
  void onResumed() {
    //应用程序可见，前台
    state.appVisible = true;
  }
}
