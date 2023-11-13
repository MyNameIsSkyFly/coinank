import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loading {
  static void show() {
    if (!EasyLoading.isShow) {
      EasyLoading.show(
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.clear,
      );
    }
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }
}
