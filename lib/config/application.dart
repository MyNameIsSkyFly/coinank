import 'package:ank_app/util/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application {
  Application._privateConstructor();

  static final Application _instance = Application._privateConstructor();

  static Application get instance {
    return _instance;
  }

  Future<void> init() async {
    await StoreLogic.init();
  }
}
