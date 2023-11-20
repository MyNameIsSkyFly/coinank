import 'package:get/get.dart';

class FundingRateSearchState {
  RxList<String> selects = RxList.empty();
  List<String> originalData = [];
  RxList<String> data = RxList.empty();
  RxBool all = false.obs;
  FundingRateSearchState() {
    Map<String, dynamic> arg = Get.arguments as Map<String, dynamic>;
    selects.value = arg['select'] as List<String>;
    originalData = arg['data'] as List<String>;
    originalData.insert(0, 'ALL');
    data.value = List.from(originalData);
  }
}
