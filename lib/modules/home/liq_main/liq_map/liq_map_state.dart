import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class LiqMapState {
  RxList<String> symbolList = RxList.empty();
  RxString symbol = ''.obs;
  RxString interval = '1d'.obs;
  RxBool isLoading = true.obs;
  InAppWebViewController? webCtrl;
  bool refreshBCanPress = true;
  ({
    bool dataReady,
    bool webReady,
    String evJS,
    bool aggDataReady,
    bool aggWebReady,
    String aggEvJS,
  }) readyStatus = (
    dataReady: false,
    webReady: false,
    evJS: '',
    aggDataReady: false,
    aggWebReady: false,
    aggEvJS: ''
  );
  RxList<String> coinList = RxList.empty();
  RxString aggCoin = ''.obs;
  RxString aggInterval = '1d'.obs;
  InAppWebViewController? aggWebCtrl;
  bool aggRefreshBCanPress = true;

  LiqMapState() {
    ///Initialize variables
  }
}
