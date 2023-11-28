import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/route/app_nav.dart';
import 'package:ank_app/util/store.dart';
import 'package:get/get.dart';

import 'contract_search_state.dart';

class ContractSearchLogic extends GetxController {
  final ContractSearchState state = ContractSearchState();

  @override
  void onReady() {
    super.onReady();
    if (state.originalList.isEmpty) {
      getData();
    }
  }

  void search(String v) {
    state.list.value = state.originalList
        .where((element) => element.symbol!.contains(v))
        .toList();
  }

  Future<void> getData() async {
    final data = await Apis().getFuturesBigData(
      page: 1,
      size: 500,
      sortBy: '',
      sortType: '',
    );
    state.originalList = data?.list ?? [];
    state.list.value = List.from(state.originalList);
    StoreLogic.to.setContractData(data?.list ?? []);
  }

  tapCollect(MarkerTickerEntity item) async {
    if (!StoreLogic.isLogin) {
      AppNav.toLogin();
    } else {
      if (item.follow == true) {
        await Apis().getDelFollow(baseCoin: item.baseCoin!);
        item.follow = false;
      } else {
        await Apis().getAddFollow(baseCoin: item.baseCoin!);
        item.follow = true;
      }
      state.list.refresh();
    }
  }

  void tapItem(MarkerTickerEntity item) {
    AppUtil.toKLine(item.exchangeName ?? '', item.symbol ?? '',
        item.baseCoin ?? '', 'SWAP');
  }
}
