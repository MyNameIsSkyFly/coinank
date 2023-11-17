import 'dart:async';

import 'package:ank_app/entity/contract_market_entity.dart';
import 'package:ank_app/widget/sort_with_arrow.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ContractMarketState {
  List<String>? headerTitles;
  List<ContractMarketEntity>? dataList;

  SortStatus priceSort = SortStatus.normal;
  SortStatus volSort = SortStatus.down;
  SortStatus oiSort = SortStatus.normal;
  SortStatus rateSort = SortStatus.normal;

  String sortType = 'descend';
  String type = 'BTC';
  String? sortBy;
  Timer? pollingTimer;
  bool isRefresh = false;
  bool appVisible = true;
  ItemScrollController itemScrollController = ItemScrollController();

  ContractMarketState() {
    ///Initialize variables
  }
}
