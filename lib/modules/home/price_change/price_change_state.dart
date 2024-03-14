import 'dart:async';

import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceChangeState {
  late bool isPrice;
  late List<String> topList;
  RxList<SortStatus> statusList = RxList<SortStatus>.empty();
  String? sortBy;

  //descend 降序
  //ascend 升序
  String sortType = 'descend';
  List<MarkerTickerEntity> originalData = [];

  ScrollController titleController = ScrollController();
  ScrollController contentController = ScrollController();
  bool isCollect = false;
  Timer? pollingTimer;
  bool isRefresh = false;
  bool appVisible = true;
  RxBool isLoading = true.obs;
  var sortByList = [];
  PriceChangeState() {
    final arg = Get.arguments;
    // ignore: avoid_dynamic_calls
    isPrice = arg?['isPrice'] as bool? ?? false;
    sortBy = isPrice ? 'priceChangeH24' : 'openInterestCh24';
    if (isPrice) {
      topList = [
        '${S.current.s_price}(\$)',
        '${S.current.s_price_chg}(24h)',
        '${S.current.s_price_chg}(5m)',
        '${S.current.s_price_chg}(15m)',
        '${S.current.s_price_chg}(30m)',
        '${S.current.s_price_chg}(1h)',
        '${S.current.s_price_chg}(4h)',
      ];
    } else {
      topList = [
        '${S.current.s_price}(\$)',
        '${S.current.s_oi_chg}(24H)',
        '${S.current.s_oi_vol}(\$)',
        '${S.current.s_oi_chg}(1H)',
        '${S.current.s_oi_chg}(4H)',
      ];
    }
    sortByList = isPrice
        ? [
            'price',
            'priceChangeH24',
            'priceChangeM5',
            'priceChangeM15',
            'priceChangeM30',
            'priceChangeH1',
            'priceChangeH4',
          ]
        : [
            'price',
            'openInterestCh24',
            'openInterest',
            'openInterestCh1',
            'openInterestCh4',
          ];
    statusList.value =
        List.generate(topList.length, (index) => SortStatus.normal);
  }
}
