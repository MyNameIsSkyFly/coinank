import 'dart:async';

import 'package:ank_app/entity/short_rate_entity.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LongShortRatioState {
  RxList<String> headerTitles = RxList.empty();
  RxString type = 'BTC'.obs;
  RxString longSortTime = '5m'.obs;
  RxString webTime = '5m'.obs;
  RxList<ShortRateEntity> dataList = RxList.empty();
  ItemScrollController itemScrollController = ItemScrollController();
  Timer? pollingTimer;
  RxBool isLoading = true.obs;
  bool isRefresh = false;
  bool appVisible = true;
  InAppWebViewController? webCtrl;
  ShortRateEntity? jsData;
  LongShortRatioState() {
    ///Initialize variables
  }
}
