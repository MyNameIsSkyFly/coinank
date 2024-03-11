import 'dart:async';

import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/widget/sort_with_arrow.dart';
import 'package:get/get.dart';

class ContractCoinState {
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
  final data = RxList<MarkerTickerEntity>();
  final oldData = RxList<MarkerTickerEntity>();

  // List<MarkerTickerEntity> get favoriteData =>
  //     data.where((element) => element.follow == true).toList();
  final favoriteData = RxList<MarkerTickerEntity>();

  // bool isCollect = false;
  Timer? pollingTimer;
  bool appVisible = true;

  // ScrollController scrollController = ScrollController();
  // ScrollController scrollControllerF = ScrollController();
  double offset = 0;
  RxBool isScrollDown = true.obs;
  RxBool isScrollDownF = true.obs;
  RxBool isLoading = true.obs;
  RxBool isLoadingF = true.obs;

  final favoriteOiSort = Rx(SortStatus.down);
  final favoriteOiChangeSort = Rx(SortStatus.normal);
  final favoritePriceSort = Rx(SortStatus.normal);
  final favoritePriceChangeSort = Rx(SortStatus.normal);

  String favoriteSortBy = 'openInterest';
  String favoriteSortType = 'descend';
  final fixedCoin = ['BTC', 'ETH', 'SOL', 'XRP', 'BNB', 'ORDI', 'DOGE', 'ARB'];
  final selectedFixedCoin = RxList<String>(
      ['BTC', 'ETH', 'SOL', 'XRP', 'BNB', 'ORDI', 'DOGE', 'ARB']);

  final fetching = RxBool(false);

  ContractCoinState();
}
