import 'dart:async';

import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/entity/search_v2_entity.dart';
import 'package:ank_app/modules/market/contract/contract_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

class HomeSearchLogic extends GetxController {
  final searchResult = RxList<SearchV2Entity>();

  final history = RxList<SearchV2ItemEntity>();
  final marked = RxList<SearchV2ItemEntity>();
  final hot = RxList<SearchV2ItemEntity>();
  final keyword = ''.obs;

  final arcList = RxList<SearchV2ItemEntity>();
  final ascList = RxList<SearchV2ItemEntity>();
  final brcList = RxList<SearchV2ItemEntity>();
  final ercList = RxList<SearchV2ItemEntity>();
  final baseList = RxList<SearchV2ItemEntity>();
  Timer? _timer;

  @override
  void onReady() {
    initHot();
    initHistory();
    initMarked();
    pollingHot();
  }

  void pollingHot() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (keyword.isNotEmpty) return;
      initHot();
    });
  }

  Future<void> initHot() async {
    final time1 = DateTime.now();
    final result = await Apis().searchV2(keyword: '');
    final now1 = DateTime.now();
    print(now1.difference(time1));
    if (result == null) return;

    final list = <SearchV2ItemEntity>[];
    for (var e in result.arc20 ?? <SearchV2ItemEntity>[]) {
      list.add(e);
    }
    for (var e in result.asc20 ?? <SearchV2ItemEntity>[]) {
      list.add(e);
    }
    for (var e in result.brc20 ?? <SearchV2ItemEntity>[]) {
      list.add(e);
    }
    for (var e in result.erc20 ?? <SearchV2ItemEntity>[]) {
      list.add(e);
    }
    for (var e in result.baseCoin ?? <SearchV2ItemEntity>[]) {
      list.add(e);
    }
    list.removeWhere((element) => element.oi == null);
    list.sort((e1, e2) => (e2.oi ?? 0).compareTo(e1.oi ?? 0));
    hot.assignAll(list.sublist(0, 20));
  }

  //init history
  void initHistory() {
    history.assignAll(StoreLogic.to.tappedSearchResult);
  }

  //init marked
  void initMarked() {
    if (!StoreLogic.isLogin) {
      marked.assignAll(StoreLogic.to.favoriteContract.map((e) =>
          SearchV2ItemEntity(baseCoin: e, tag: SearchEntityType.BASECOIN)));
    } else {
      final list = Get.find<ContractLogic>()
          .state
          .data
          .where((p0) => p0.follow == true)
          .map((e) => SearchV2ItemEntity(
              baseCoin: e.baseCoin, tag: SearchEntityType.BASECOIN));
      marked.assignAll(list);
    }
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
    await Get.find<ContractLogic>().tapFavoriteCollect(item.baseCoin);
    initMarked();
  }

  Future<void> unMark(SearchV2ItemEntity item) async {
    await Get.find<ContractLogic>().tapFavoriteCollect(item.baseCoin);
    initMarked();
  }

  Future<void> search(String keyword) async {
    final result = await Apis().searchV2(keyword: keyword);
    this.keyword.value = keyword;
    if (result == null) return;
    ascList.assignAll(result.asc20 ?? <SearchV2ItemEntity>[]);
    brcList.assignAll(result.brc20 ?? <SearchV2ItemEntity>[]);
    arcList.assignAll(result.arc20 ?? <SearchV2ItemEntity>[]);
    ercList.assignAll(result.erc20 ?? <SearchV2ItemEntity>[]);
    baseList.assignAll(result.baseCoin ?? <SearchV2ItemEntity>[]);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
