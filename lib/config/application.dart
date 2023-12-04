import 'dart:convert';

import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/util/jpush_util.dart';
import 'package:dio/dio.dart';

class Application {
  Application._privateConstructor();

  static final Application _instance = Application._privateConstructor();

  static Application get instance {
    return _instance;
  }

  Future<void> init() async {
    await StoreLogic.init();
    MessageFlutterApi.setup(FlutterApiManager());
    EasyRefresh.defaultHeaderBuilder = () => const MaterialHeader();
    JPushUtil().initPlatformState();
    await initConfig();
  }

  Future initConfig() async {
    for (int i = 0; i < 10; i++) {
      final success = await getConfig();
      if (success == false) {
        await Future.delayed(const Duration(seconds: 3));
        continue;
      }
      break;
    }
  }

  Future<bool> getConfig() async {
    final result = await Dio()
        .get('https://coinsoho.s3.us-east-2.amazonaws.com/app/config.txt');
    if (result.statusCode != 200) return false;
    final data = jsonDecode(result.data)['data'];

    await Future.wait([
      StoreLogic.to.saveChartUrl(data['ank_charturl']),
      StoreLogic.to.saveUniappDomain(data['ank_uniappDomain']),
      StoreLogic.to.saveDomain(data['ank_domain']),
      StoreLogic.to.saveWebsocketUrl(data['ank_websocketUrl']),
      StoreLogic.to.saveApiPrefix(data['ank_apiPrefix']),
      StoreLogic.to.saveH5Prefix(data['ank_h5Prefix']),
      StoreLogic.to.saveDepthOrderDomain(data['newDepthOrderDomain']),
    ]);
    return true;
  }
}

class FlutterApiManager extends MessageFlutterApi {
  @override
  void toKLine(String exchangeName, String symbol, String baseCoin,
      String? productType) {
    AppUtil.toKLine(exchangeName, symbol, baseCoin, productType);
  }

}
