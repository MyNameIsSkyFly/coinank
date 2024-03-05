import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

class ReorderLogic extends GetxController {
  final list = <MapEntry<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() {
    final order = StoreLogic.to.contractCoinSortOrder;
    list.assignAll(order.entries.where((element) => element.value == true));
  }
}
