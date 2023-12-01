import 'package:get/get.dart';

class CustomSearchBottomSheetState {
  late List<String> originalDataList;
   RxList<String> dataList = RxList.empty();

  RxString current = ''.obs;

  CustomSearchBottomSheetState() {
    Map<String, dynamic> arg = Get.arguments as Map<String, dynamic>;
    originalDataList = arg['list'] as List<String>;
    dataList.value = List.from(originalDataList);
    current.value = arg['current'] as String;
  }
}
