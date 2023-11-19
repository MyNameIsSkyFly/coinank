import 'package:get/get.dart';

class CustomBottomSheetState {
  late String title;
  late List<String> dataList;
   RxString current = ''.obs;

  CustomBottomSheetState() {
    Map<String, dynamic> arg = Get.arguments as Map<String, dynamic>;
    title = arg['title'] as String;
    dataList = arg['list'] as List<String>;
    current.value = arg['current'] as String;
  }
}
