import 'package:get/get.dart';

import 'funding_rate_state.dart';

class FundingRateLogic extends GetxController {
  final FundingRateState state = FundingRateState();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.titleController.addListener(_updateContent);
    state.contentController.addListener(_updateTitle);
  }

  void _updateTitle() {
    if (state.titleController.offset != state.contentController.offset) {
      state.titleController.jumpTo(state.contentController.offset);
    }
  }

  void _updateContent() {
    if (state.contentController.offset != state.titleController.offset) {
      state.contentController.jumpTo(state.titleController.offset);
    }
  }

 @override
  void onClose() {
   state.titleController.removeListener(_updateContent);
   state.contentController.removeListener(_updateTitle);
    super.onClose();
  }
}
