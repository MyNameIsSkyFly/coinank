import 'dart:async';

import 'package:ank_app/entity/marker_funding_rate_entity.dart';
import 'package:ank_app/widget/sort_with_arrow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FundingRateState {
  RxBool isHide = true.obs; //是否隐藏
  RxBool isCmap = false.obs; //是U本位
  String timeType = 'current';
  RxString time = ''.obs;
  RxList<String> topList =
      ['Binance', 'Okex', 'Bybit', 'Bitget', 'Gate', 'dYdX', 'Huobi'].obs;
  RxList<SortStatus> topStatusList = [
    SortStatus.normal,
    SortStatus.normal,
    SortStatus.normal,
    SortStatus.normal,
    SortStatus.normal,
    SortStatus.normal,
    SortStatus.normal
  ].obs;
  final ScrollController titleController = ScrollController();
  final ScrollController contentController = ScrollController();
  final ScrollController scrollController = ScrollController();

  List<MarkerFundingRateEntity>? contentOriginalDataList;
  RxList<MarkerFundingRateEntity> contentDataList = RxList.empty();
  List<String> searchList = [];
  int sortIndex = 0;
  Timer? pollingTimer;
  bool isRefresh = false;
  bool appVisible  = true;
  FundingRateState() {
    ///Initialize variables
  }
}
