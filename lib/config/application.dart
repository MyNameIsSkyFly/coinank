import 'dart:convert';

import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/util/store.dart';
import 'package:get/get.dart';

class Application {
  Application._privateConstructor();

  static final Application _instance = Application._privateConstructor();

  static Application get instance {
    return _instance;
  }

  Future<void> init() async {
    await StoreLogic.init();
    MessageFlutterApi.setup(FlutterApiManager());
    EasyRefresh.defaultHeaderBuilder = () => const CupertinoHeader();
  }
}

class FlutterApiManager extends MessageFlutterApi {
  @override
  void toKLine(String exchangeName, String symbol, String baseCoin,
      String? productType) {
    Map<String, dynamic> map = {
      'symbol': symbol,
      'baseCoin': baseCoin,
      'exchangeName': exchangeName,
      'productType': productType ?? 'SWAP',
    };
    String js = "flutterOpenKline('${jsonEncode(map)}');";
    Get.find<MainLogic>()
        .state
        .webViewController
        ?.evaluateJavascript(source: js);
    Get.find<MainLogic>().selectTab(2);
  }
}
