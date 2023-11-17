import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:get/get.dart';

class ContractSearchState {
  RxList<MarkerTickerEntity> list = RxList<MarkerTickerEntity>();
  late List<MarkerTickerEntity> originalList;

  ContractSearchState() {
    originalList = Get.arguments as List<MarkerTickerEntity>;
    list.value = List.from(originalList);
  }
}
