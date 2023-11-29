import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class LiqMapState {
  RxList<String> symbolList = RxList.empty();
  RxString symbol = ''.obs;
  RxString interval = '1d'.obs;
  RxBool isLoading = true.obs;
  InAppWebViewController? webCtrl;
  bool refreshBCanPress = true;
  LiqMapState() {
    ///Initialize variables
  }
}
