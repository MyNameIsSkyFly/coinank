import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class LiqHotMapState {
  RxList<String> symbolList = RxList.empty();
  RxString symbol = ''.obs;
  RxString interval = '1d'.obs;
  RxBool isLoading = true.obs;
  InAppWebViewController? webCtrl;
  bool refreshBCanPress = true;
  ({bool dataReady, bool webReady, String evJS}) readyStatus =
      (dataReady: false, webReady: false, evJS: '');

  LiqHotMapState() {
    ///Initialize variables
  }
}
