import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

class ReorderSpotLogic extends GetxController {
  final list = <MapEntry<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() {
    final order = StoreLogic.to.spotSortOrder;
    list.assignAll(order.entries.where((element) => element.value == true));
  }
}
