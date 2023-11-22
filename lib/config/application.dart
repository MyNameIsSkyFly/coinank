import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/util/store.dart';

class Application {
  Application._privateConstructor();

  static final Application _instance = Application._privateConstructor();

  static Application get instance {
    return _instance;
  }

  Future<void> init() async {
    await StoreLogic.init();
    MessageFlutterApi.setup(FlutterApiManager());
  }
}

class FlutterApiManager extends MessageFlutterApi {
  @override
  void toKLine(String exchangeName, String symbol) {
    print('exchangeName:$exchangeName--$symbol');
  }
}
