import 'package:get/get.dart';

import 'custom_search_bottom_sheet_state.dart';

class CustomSearchBottomSheetLogic extends GetxController {
  final CustomSearchBottomSheetState state = CustomSearchBottomSheetState();
  void search(String v) {
    state.dataList.value =
        state.originalDataList.where((element) => element.contains(v)).toList();
  }
  void tapCell(int index) {
    state.current.value = state.dataList[index];
    Get.back(result: state.current.value);
  }
}
