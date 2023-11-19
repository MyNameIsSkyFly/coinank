import 'package:ank_app/entity/marker_funding_rate_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FundingRateState {
  RxBool isHide = true.obs; //是否隐藏
  RxBool isCmap = false.obs; //是U本位
  String timeType = 'current';
  RxString time = ''.obs;
  RxList<String> topList =
      ['Binance', 'Okex', 'Bybit', 'Bitget', 'Gate', 'dYdX', 'Huobi'].obs;
  final ScrollController titleController = ScrollController();
  final ScrollController contentController = ScrollController();
  RxList<MarkerFundingRateEntity> contentDataList = RxList.empty();

  FundingRateState() {
    ///Initialize variables
  }
}
