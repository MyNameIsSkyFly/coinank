import 'package:get/get.dart';

import '../../widget/common_webview.dart';
import 'main_state.dart';

class MainLogic extends GetxController {
  final MainState state = MainState();

  @override
  void onReady() {
    CommonWebView.setCookieValue();
    super.onReady();
  }

  void selectTab(int currentIndex) {
    if (state.selectedIndex.value != currentIndex) {
      state.selectedIndex.value = currentIndex;
      state.pageController.jumpToPage(currentIndex);
    }
  }
}
