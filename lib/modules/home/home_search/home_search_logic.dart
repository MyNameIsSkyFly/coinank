import 'dart:async';

import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/entity/search_v2_entity.dart';
import 'package:ank_app/modules/home/home_search/home_search_view.dart';
import 'package:ank_app/modules/market/spot/favorite/spot_coin_logic_f.dart';
import 'package:ank_app/res/export.dart';
import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:get/get.dart';

import '../../market/contract/contract_coin/favorite/contract_coin_logic_f.dart';

class HomeSearchLogic extends GetxController {
  final searchResult = RxList<SearchV2Entity>();

  final history = RxList<SearchV2ItemEntity>();
  final hot = RxList<SearchV2ItemEntity>();
  final keyword = ''.obs;

  final arcList = RxList<SearchV2ItemEntity>();
  final ascList = RxList<SearchV2ItemEntity>();
  final brcList = RxList<SearchV2ItemEntity>();
  final ercList = RxList<SearchV2ItemEntity>();
  final contractList = RxList<SearchV2ItemEntity>();
  final spotList = RxList<SearchV2ItemEntity>();
  Timer? _timer;
  final textTrigger = RxString('');
  @override
  void onReady() {
    initHot();
    initHistory();
    pollingHot();
    initDebounce();
  }

  void initDebounce() {
    debounce(textTrigger, search);
  }

  void pollingHot() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!AppConst.canRequest) return;
      if (keyword.isNotEmpty) return;
      if (Get.currentRoute == HomeSearchPage.routeName) {
        initHot();
      }
    });
  }

  Future<void> initHot() async {
    final result = await Apis().searchV2(keyword: '');
    if (result == null) return;

    final list = <SearchV2ItemEntity>[];
    for (final e in result.arc20 ?? <SearchV2ItemEntity>[]) {
      list.add(e);
    }
    for (final e in result.asc20 ?? <SearchV2ItemEntity>[]) {
      list.add(e);
    }
    for (final e in result.brc20 ?? <SearchV2ItemEntity>[]) {
      list.add(e);
    }
    for (final e in result.erc20 ?? <SearchV2ItemEntity>[]) {
      list.add(e);
    }
    for (final e in result.baseCoin ?? <SearchV2ItemEntity>[]) {
      list.add(e);
    }
    list
      ..removeWhere((element) => element.oi == null)
      ..sort((e1, e2) => (e2.oi ?? 0).compareTo(e1.oi ?? 0));
    hot.assignAll(list.sublist(0, 20));
  }

  //init history
  Future<void> initHistory() async {
    final tapped = StoreLogic.to.tappedSearchResult;
    await Future.wait(tapped.map((item) async {
      if (item.tag == SearchEntityType.BASECOIN &&
          (item.exchangeName == null ||
              item.symbol == null ||
              item.supportContract == null ||
              item.supportSpot == null)) {
        final value = await Apis().searchV2(keyword: item.baseCoin ?? '');
        final baseCoinList = value?.baseCoin;
        final tmp = baseCoinList
            ?.firstWhereOrNull((element) => element.baseCoin == item.baseCoin);
        await tmp?.let((it) async => StoreLogic.to.saveTappedSearchResult(it));
      }
    }));
    history.assignAll(StoreLogic.to.tappedSearchResult);
  }

  Future<void> clearHistory() async {
    await StoreLogic.to.clearTappedSearchResult();
    initHistory();
  }

  Future<void> onTapItem(SearchV2ItemEntity item) async {
    // https://coinank.com/ordinals/brc20/ORDI
    // https://coinank.com/ordinals/arc20/quark
    // https://coinank.com/scriptions/asc20/avav
    // https://coinank.com/scriptions/erc20/eths
    switch (item.tag) {
      case SearchEntityType.ARC20:
        AppNav.openWebUrl(
            url:
                'https://coinank.com/${AppUtil.webLanguage}ordinals/arc20/${Uri.encodeComponent(item.baseCoin ?? '')}',
            showLoading: true,
            dynamicTitle: true,
            title: item.baseCoin);
      case SearchEntityType.BRC20:
        AppNav.openWebUrl(
            url:
                'https://coinank.com/${AppUtil.webLanguage}ordinals/brc20/${Uri.encodeComponent(item.baseCoin ?? '')}',
            dynamicTitle: true,
            showLoading: true,
            title: item.baseCoin);
      case SearchEntityType.ASC20:
        AppNav.openWebUrl(
            url:
                'https://coinank.com/${AppUtil.webLanguage}scriptions/asc20/${Uri.encodeComponent(item.baseCoin ?? '')}',
            dynamicTitle: true,
            showLoading: true,
            title: item.baseCoin);
      case SearchEntityType.ERC20:
        AppNav.openWebUrl(
            url:
                'https://coinank.com/${AppUtil.webLanguage}scriptions/erc20/${Uri.encodeComponent(item.baseCoin ?? '')}',
            dynamicTitle: true,
            showLoading: true,
            title: item.baseCoin);
      case SearchEntityType.BASECOIN:
        AppNav.toCoinDetail(MarkerTickerEntity(
          baseCoin: item.baseCoin,
          exchangeName: item.exchangeName,
          symbol: item.symbol,
          supportContract: item.supportContract,
          supportSpot: item.supportSpot,
        ));
      // AppNav.openWebUrl(
      //     url:
      //         'https://coinank.com/${AppUtil.webLanguage}instruments/${Uri.encodeComponent(item.baseCoin ?? '')}',
      //     dynamicTitle: true,
      //     showLoading: true,
      //     title: item.baseCoin);
      case null:
        break;
    }
    await StoreLogic.to.saveTappedSearchResult(item);
    initHistory();
  }

  Future<void> mark(SearchV2ItemEntity item) async {
    if (item.isSpot) {
      await Get.find<SpotCoinLogicF>().tapCollect(item.baseCoin);
    } else {
      await Get.find<ContractCoinLogicF>().tapCollect(item.baseCoin);
    }
    item.isFollow = !item.isFollow;
    if (item.isSpot) {
      spotList.refresh();
    } else {
      contractList.refresh();
    }
  }

  Future<void> search(String keyword) async {
    final requestQueue = <Future>[Apis().searchV2(keyword: keyword)];
    final results = await Future.wait(requestQueue);
    if (StoreLogic.isLogin) {
      results
        ..insert(
            1,
            TickersDataEntity(
                list: Get.find<ContractCoinLogicF>().data.toList()))
        ..add(
            TickersDataEntity(list: Get.find<SpotCoinLogicF>().data.toList()));
    }
    final result = results[0] as SearchV2Entity?;
    this.keyword.value = keyword;
    if (result == null) return;
    ascList.assignAll(result.asc20 ?? <SearchV2ItemEntity>[]);
    brcList.assignAll(result.brc20 ?? <SearchV2ItemEntity>[]);
    arcList.assignAll(result.arc20 ?? <SearchV2ItemEntity>[]);
    ercList.assignAll(result.erc20 ?? <SearchV2ItemEntity>[]);
    final contractItems = result.baseCoin
            ?.where((element) => element.supportContract == true)
            .map((e) => SearchV2ItemEntity.fromJson(e.toJson()))
            .toList() ??
        <SearchV2ItemEntity>[];
    final spotItems = result.baseCoin
            ?.where((element) => element.supportSpot == true)
            .map((e) => SearchV2ItemEntity.fromJson(e.toJson())..isSpot = true)
            .toList() ??
        <SearchV2ItemEntity>[];
    if (StoreLogic.isLogin) {
      final favoriteContracts = (results[1] as TickersDataEntity?)?.list;
      final favoriteSpots = (results[2] as TickersDataEntity?)?.list;
      for (final element in contractItems) {
        element.isFollow =
            favoriteContracts?.any((e) => e.baseCoin == element.baseCoin) ??
                false;
      }
      for (final element in spotItems) {
        element.isFollow =
            favoriteSpots?.any((e) => e.baseCoin == element.baseCoin) ?? false;
      }
    } else {
      final favoriteContracts = StoreLogic().favoriteContract;
      final favoriteSpot = StoreLogic().favoriteSpot;
      for (final element in contractItems) {
        element.isFollow = favoriteContracts.contains(element.baseCoin);
      }
      for (final element in spotItems) {
        element.isFollow = favoriteSpot.contains(element.baseCoin);
      }
    }
    contractList.assignAll(contractItems);
    spotList.assignAll(spotItems);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
