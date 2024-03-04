import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/util/store.dart';
import 'package:get/get.dart';

class ContractSearchState {
  RxList<MarkerTickerEntity> list = RxList<MarkerTickerEntity>();
  late List<MarkerTickerEntity> originalList;

  ContractSearchState() {
    originalList = StoreLogic.to.contractData.toList();
    list.value = List.from(originalList);
  }
}
