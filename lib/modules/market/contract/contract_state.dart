import 'dart:async';

import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/widget/sort_with_arrow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContractState {
  SortStatus oiSort = SortStatus.down;
  SortStatus oiChangeSort = SortStatus.normal;
  SortStatus priceSort = SortStatus.normal;
  SortStatus priceChangSort = SortStatus.normal;

  //openInterestCh24 持仓变化
  //openInterest 持仓
  //price 价格
  //priceChangeH24 价格变化
  //liquidationH24 爆仓变化
  String sortBy = 'openInterest';

  //descend 降序
  //ascend 升序
  String sortType = 'descend';
  List<MarkerTickerEntity>? data;
  List<MarkerTickerEntity>? originalData;
  List<MarkerTickerEntity>? oldData;

  bool isCollect = false;
  Timer? pollingTimer;
  bool isRefresh = false;
  bool appVisible = true;
  ScrollController scrollController = ScrollController();
  double offset = 0;
  RxBool isScrollDown = true.obs;
  RxBool isLoading = true.obs;
  ContractState();
}
