import 'package:get/get.dart';

class StoreLogic extends GetxController {
  static StoreLogic get to => Get.find();
  RxString locale = ''.obs;

  setLocale(String v) {
    locale.value = v;
    update(['locale']);
  }
}

class SP {
  static const String keyLocale = 'key_locale';
}
