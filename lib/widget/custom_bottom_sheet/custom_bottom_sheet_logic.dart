import 'package:get/get.dart';

import 'custom_bottom_sheet_state.dart';

class CustomBottomSheetLogic extends GetxController {
  final CustomBottomSheetState state = CustomBottomSheetState();

  void tapCell(int index) {
    state.current.value = state.dataList[index];
    Get.back(result: state.current.value);
  }
}
