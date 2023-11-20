import 'dart:async';

import 'package:ank_app/entity/marker_funding_rate_entity.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/modules/market/funding_rate_search/funding_rate_search_view.dart';
import 'package:ank_app/modules/market/market_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/custom_bottom_sheet/custom_bottom_sheet_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'funding_rate_state.dart';

class FundingRateLogic extends FullLifeCycleController with FullLifeCycleMixin{
  final FundingRateState state = FundingRateState();

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
      startTimer(showLoading: true);
    }
  }

  void tapSort(int idx) {
    state.sortIndex = idx;
    SortStatus sortStatus = state.topStatusList.toList()[idx];
    switch (sortStatus) {
      case SortStatus.normal:
        sortStatus = SortStatus.up;
      case SortStatus.up:
        sortStatus = SortStatus.down;
      case SortStatus.down:
        sortStatus = SortStatus.normal;
    }
    List<SortStatus> list =
        List.generate(state.topList.length, (index) => SortStatus.normal);
    list[idx] = sortStatus;
    state.topStatusList.value = list;
    sort(state.topList.toList()[idx], sortStatus);
  }

  void sort(String exchangeName, SortStatus sortBy) {
    List<MarkerFundingRateEntity> list =
        List.from(state.contentOriginalDataList ?? []);
    list = list
        .where((element) =>
            state.searchList.contains(element.symbol) ||
            state.searchList.isEmpty)
        .toList();
    if (sortBy == SortStatus.normal) {
      state.contentDataList.value = list;
      return;
    }
    list.sort((a, b) {
      double? first;
      double? second;
      if (state.isCmap.value) {
        first = a.cmap?[exchangeName]?.fundingRate;
        second = b.cmap?[exchangeName]?.fundingRate;
      } else {
        first = a.umap?[exchangeName]?.fundingRate;
        second = b.umap?[exchangeName]?.fundingRate;
      }
      if (first == null && second == null) {
        return 0;
      } else if (first == null) {
        return 1;
      } else if (second == null) {
        return -1;
      }
      if (first == 0 && second == 0) {
        return 0;
      } else if (first == 0) {
        return 1;
      } else if (second == 0) {
        return -1;
      }
      if (sortBy == SortStatus.up) {
        return first.compareTo(second);
      } else {
        return second.compareTo(first);
      }
    });
    state.contentDataList.value = list;
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
      sort(state.topList.toList()[state.sortIndex],
          state.topStatusList.toList()[state.sortIndex]);
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

  Future<void> _onRefresh({bool showLoading = false}) async {
    if (showLoading) {
      Loading.show();
    }
    state.isRefresh = true;
    final data = await Apis().getMarketFundingRateData(type: state.timeType);
    Loading.dismiss();
    state.isRefresh = false;
    if (data != null) {
      state.contentOriginalDataList = data;
      sort(state.topList.toList()[state.sortIndex],
          state.topStatusList.toList()[state.sortIndex]);
    }
  }

  startTimer({bool showLoading = false}) async {
    cancelTimer();
    await _onRefresh(showLoading: showLoading);
    state.pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      timer.cancel();
      if (Get.find<MainLogic>().state.selectedIndex.value == 1 &&
          !state.isRefresh &&
          Get.find<MarketLogic>().state.tabController?.index == 3 &&
          state.appVisible) {
        startTimer(showLoading: false);
      }
    });
  }

  cancelTimer() {
    state.pollingTimer?.cancel();
    state.pollingTimer = null;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    state.titleController.addListener(_updateContent);
    state.contentController.addListener(_updateTitle);
  }


  @override
  void onClose() {
    state.titleController.removeListener(_updateContent);
    state.contentController.removeListener(_updateTitle);
    WidgetsBinding.instance.removeObserver(this);
    cancelTimer();
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
    cancelTimer();
  }

  @override
  void onResumed() {
    //应用程序可见，前台
    state.appVisible = true;
    if (!state.appVisible) {
      startTimer();
    }
  }
}
