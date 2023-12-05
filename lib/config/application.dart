import 'dart:convert';

import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/util/jpush_util.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class Application {
  Application._privateConstructor();

  static final Application _instance = Application._privateConstructor();

  static Application get instance {
    return _instance;
  }

  Future<void> init() async {
    await Future.wait([StoreLogic.init(), checkNetwork()]);
    MessageFlutterApi.setup(FlutterApiManager());
    EasyRefresh.defaultHeaderBuilder = () => const MaterialHeader();
    JPushUtil().initPlatformState();
    await CommonWebView.setCookieValue();
    await initConfig();
  }

  Future initConfig() async {
    if (!StoreLogic.to.isFirst) {
      await getConfig();
    } else {
      StoreLogic.to.saveIsFirst(false);
    }
  }

  Future<bool> getConfig() async {
    final result = await Dio()
        .get('https://coinsoho.s3.us-east-2.amazonaws.com/app/config.txt')
        .catchError((e) {
      return Response(requestOptions: RequestOptions());
    });
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

  static Future<void> checkNetwork() async {
    var connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();
    AppConst.networkConnected = result != ConnectivityResult.none;
  }
}

class FlutterApiManager extends MessageFlutterApi {
  @override
  void toKLine(String exchangeName, String symbol, String baseCoin,
      String? productType) {
    AppUtil.toKLine(exchangeName, symbol, baseCoin, productType);
  }
}
