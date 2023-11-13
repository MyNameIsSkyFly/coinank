import 'package:ank_app/util/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application {
  Application._privateConstructor();

  static final Application _instance = Application._privateConstructor();

  static Application get instance {
    return _instance;
  }

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? locale = prefs.getString(SP.keyLocale);
    StoreLogic.to.setLocale(locale ?? '');
  }
}
