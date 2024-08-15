import 'dart:async';

import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/modules/home/price_change/_grid_source.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/triple_state_sort_button.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'price_change_state.dart';

class PriceChangeLogic extends GetxController {
  final PriceChangeState state = PriceChangeState();
  late final gridSource = PriceChgGridSource(list: []);

  final columns = RxList<GridColumn>();

  void getColumns() {
    final items = [
      GridColumn(
          columnName: 'Coin',
          width: 120,
          autoFitPadding: EdgeInsets.zero,
          label: Builder(builder: (context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              width: 120,
              alignment: Alignment.centerLeft,
              child: Text(
                'Coin',
                style: Styles.tsSub_12(context),
              ),
            );
          })),
      ...state.topList.mapIndexed((index, e) => GridColumn(
            columnName: e,
            autoFitPadding: const EdgeInsets.symmetric(horizontal: 10),
            label: Builder(builder: (context) {
              return Row(
                children: [
                  const Gap(10),
                  Flexible(
                      child: Text(
                    e,
                    style: Styles.tsSub_12(context),
                    textAlign: TextAlign.center,
                  )),
                  const Gap(4),
                  TripleStateSortIcon(
                      isAsc: state.sortByList[index] == state.sortBy
                          ? state.sortType == 'ascend'
                          : null)
                ],
              );
            }),
          ))
    ];
    columns.assignAll(items);
  }

  Future<void> tapSort(int idx) async {
    state.sortBy = state.sortByList[idx];
    if (state.statusList[idx] == SortStatus.normal) {
      state.statusList[idx] = SortStatus.down;
      state.sortType = 'descend';
    } else if (state.statusList[idx] == SortStatus.down) {
      state.statusList[idx] = SortStatus.up;
      state.sortType = 'ascend';
    } else {
      state.statusList[idx] = SortStatus.normal;
      state
        ..sortType = 'descend'
        ..sortBy = '';
    }
    final statusList = List<SortStatus>.generate(
        state.topList.length, (index) => SortStatus.normal);
    statusList[idx] = state.statusList[idx];
    state.statusList.value = List.from(statusList);
    await onRefresh(true);
    getColumns();
  }

  void tapItem(MarkerTickerEntity item) {
    AppNav.toCoinDetail(item);
  }

  Future<void> onRefresh(bool showLoading) async {
    state.isRefresh = true;
    if (showLoading) Loading.show();
    if (state.isPrice) {
      await getBigData().whenComplete(Loading.dismiss);
    } else {
      await getOiData().whenComplete(Loading.dismiss);
    }
    state.isLoading.value = false;
    Loading.dismiss();
    state.isRefresh = false;
    getColumns();
  }

  Future<void> getOiData() async {
    final data = await Apis().postFuturesBigData(
      {'openInterest': '3000000~'},
      page: 1,
      size: 100,
      sortBy: state.sortBy,
      sortType: state.sortType,
    );
    gridSource.list.assignAll(data?.list ?? []);
    gridSource.buildDataGridRows();
    state.originalData.assignAll(data?.list ?? []);
  }

  Future<void> getBigData() async {
    final data = await Apis().getFuturesBigData(
      page: 1,
      size: 100,
      sortBy: state.sortBy,
      sortType: state.sortType,
      // sort: 'priceChangeH24',
    );
    gridSource.list.assignAll(data?.list ?? []);
    gridSource.buildDataGridRows();
    state.originalData.assignAll(data?.list ?? []);
  }

  void _startTimer() {
    state.pollingTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!state.isRefresh && AppConst.canRequest) {
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
    onRefresh(true);
  }

  @override
  void onInit() {
    super.onInit();
    state.titleController.addListener(_updateContent);
    state.contentController.addListener(_updateTitle);
    _startTimer();
    getColumns();
  }

  @override
  void onClose() {
    state.titleController.removeListener(_updateContent);
    state.contentController.removeListener(_updateTitle);
    state.pollingTimer?.cancel();
    state.pollingTimer = null;
    super.onClose();
  }
}
