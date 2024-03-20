import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

class ReorderSpotLogic extends GetxController {
  final list = <MapEntry<String, dynamic>>[].obs;
  var isCategory = false;

  @override
  void onInit() {
    isCategory = Get.arguments['isCategory'] ?? false;
    initData();
    super.onInit();
  }

  void initData() {
    late Map<String, bool> order;
    if (!isCategory) {
      order = StoreLogic.to.spotSortOrder;
    } else {
      order = StoreLogic.to.categorySpotOrder;
    }
    list.assignAll(order.entries.where((element) => element.value == true));
  }
}
