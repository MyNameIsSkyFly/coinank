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

  static Future<T> wrap<T>(Future<T> Function() future) async {
    show();
    T data;
    try {
      data = await future();
    } on Exception catch (_) {
      rethrow;
    } finally {
      dismiss();
    }
    return data;
  }
}
