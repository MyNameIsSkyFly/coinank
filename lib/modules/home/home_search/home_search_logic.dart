import 'package:ank_app/entity/search_v2_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

class HomeSearchLogic extends GetxController {
  final searchResult = RxList<SearchV2Entity>();

  final history = RxList<SearchV2ItemEntity>();
  final marked = RxList<SearchV2ItemEntity>();
  final hot = RxList<SearchV2ItemEntity>();

  @override
  void onReady() {
    initHot();
    initHistory();
    initMarked();
  }

  Future<void> initHot() async {
    final result = await Apis().searchV2();
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
    marked.assignAll(StoreLogic.to.markedSearchResult);
  }

  Future<void> clearHistory() async {
    await StoreLogic.to.clearTappedSearchResult();
    initHistory();
  }

  Future<void> mark(SearchV2ItemEntity item) async {
    await StoreLogic.to.saveMarkedSearchResult(item);
    initMarked();
  }

  Future<void> unMark(SearchV2ItemEntity item) async {
    await StoreLogic.to.removeMarkedSearchResult(item);
    initMarked();
  }

  void search(String keyword) {}
}
