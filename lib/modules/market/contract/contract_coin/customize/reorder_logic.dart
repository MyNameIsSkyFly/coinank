import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

class ReorderLogic extends GetxController {
  final list = <MapEntry<String, dynamic>>[];

  @override
  void onInit() {
    initData();
    super.onReady();
  }

  void initData() {
    final order = StoreLogic.to.contractCoinSortOrder as Map<String, dynamic>;
    list.assignAll(order.entries);
  }
}
