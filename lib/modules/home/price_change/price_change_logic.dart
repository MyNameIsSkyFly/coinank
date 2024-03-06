import 'dart:async';

import 'package:ank_app/entity/body/futures_big_data_body.dart';
import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'price_change_state.dart';

class PriceChangeLogic extends FullLifeCycleController with FullLifeCycleMixin {
  final PriceChangeState state = PriceChangeState();

  Future<void> tapSort(int idx) async {
    if (state.isPrice) {
      switch (idx) {
        case 0:
          state.sortBy = 'price';
        case 1:
          state.sortBy = 'priceChangeM5';
        case 2:
          state.sortBy = 'priceChangeM15';
        case 3:
          state.sortBy = 'priceChangeM30';
        case 4:
          state.sortBy = 'priceChangeH1';
        case 5:
          state.sortBy = 'priceChangeH4';
        case 6:
          state.sortBy = 'priceChangeH24';
        default:
          break;
      }
    } else {
      switch (idx) {
        case 0:
          state.sortBy = 'price';
        case 1:
          state.sortBy = 'openInterest';
        case 2:
          state.sortBy = 'openInterestCh1';
        case 3:
          state.sortBy = 'openInterestCh4';
        case 4:
          state.sortBy = 'openInterestCh24';
        default:
          break;
      }
    }
    if (state.statusList[idx] == SortStatus.normal) {
      state.statusList[idx] = SortStatus.down;
      state.sortType = 'descend';
    } else if (state.statusList[idx] == SortStatus.down) {
      state.statusList[idx] = SortStatus.up;
      state.sortType = 'ascend';
    } else {
      state.statusList[idx] = SortStatus.normal;
      state.sortType = 'descend';
      state.sortBy = '';
    }
    List<SortStatus> statusList =
        List.generate(state.topList.length, (index) => SortStatus.normal);
    statusList[idx] = state.statusList[idx];
    state.statusList.value = List.from(statusList);
    await onRefresh(true);
  }

  void tapItem(MarkerTickerEntity item) {
    AppNav.toCoinDetail(item);
  }

  Future<void> onRefresh(bool showLoading) async {
    state.oldContentDataList = List.from(state.originalData ?? []);
    state.isRefresh = true;
    if (showLoading) {
      Loading.show();
    }
    if (state.isPrice) {
      await getBigData();
    } else {
      await getOiData();
    }
    state.isLoading.value = false;
    Loading.dismiss();
    state.isRefresh = false;
  }

  Future<void> getOiData() async {
    final data = await Apis().postFuturesBigData(
      const FuturesBigDataBody(openInterest: '3000000~'),
      page: 1,
      size: 100,
      sortBy: state.sortBy,
      sortType: state.sortType,
    );
    state.originalData = data?.list;
    state.contentDataList.value = List.from(state.originalData ?? []);
  }

  Future<void> getBigData() async {
    final data = await Apis().getFuturesBigData(
      page: 1,
      size: 100,
      sortBy: state.sortBy,
      sortType: state.sortType,
      sort: 'priceChangeH24',
    );
    state.originalData = data?.list;
    state.contentDataList.value = List.from(state.originalData ?? []);
  }

  _startTimer() async {
    state.pollingTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!state.isRefresh && state.appVisible) {
        await onRefresh(false);
      }
    });
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

  @override
  void onReady() {
    super.onReady();
    onRefresh(false);
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    state.titleController.addListener(_updateContent);
    state.contentController.addListener(_updateTitle);
    _startTimer();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
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
