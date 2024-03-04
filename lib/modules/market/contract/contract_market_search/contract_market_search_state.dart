import 'package:get/get.dart';

class ContractMarketSearchState {
  RxList<String> list = RxList<String>();
  late List<String> originalList;

  ContractMarketSearchState() {
    originalList = Get.arguments as List<String>;
    list.value = List.from(originalList);
  }

}
