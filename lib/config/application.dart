// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';

import '../constants/urls.dart';

class Application {
  Application._privateConstructor();

  static final Application _instance = Application._privateConstructor();

  static Application get instance {
    return _instance;
  }

  Future<void> init() async {
    await Future.wait([StoreLogic.init(), checkNetwork()]);
    MessageFlutterApi.setup(FlutterApiManager());
    // material_indicator.dart 中修改以解决rebuild的问题
    // double? get _value 中添加:
    // if (_mode == IndicatorMode.inactive) return 0;
    EasyRefresh.defaultHeaderBuilder = () => const MaterialHeader();
    initLoading();
    await CommonWebView.setCookieValue();
    if (Platform.isAndroid) {
      initConfig();
    } else {
      await initConfig();
    }
  }

  void initLoading() {
    EasyLoading.instance
      ..indicatorWidget = Lottie.asset(
          StoreLogic.to.isDarkMode == true
              ? 'assets/lottie/loading_dark.json'
              : 'assets/lottie/loading_light.json',
          repeat: true,
          animate: true,
          width: 60,
          height: 60)
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor =
          StoreLogic.to.isDarkMode == true ? Colors.black : Colors.white
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..radius = 12
      ..userInteractions = false;
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
      StoreLogic.to.saveKlineUrl(data['ank_kline_url']),
      StoreLogic.to.saveHeatMapUrl(data['ank_heatmap_url']),
      StoreLogic.to.saveUniappDomain(data['ank_uniappDomain']),
      StoreLogic.to.saveDomain(data['ank_domain']),
      StoreLogic.to.saveWebsocketUrl(data['ank_websocketUrl']),
      StoreLogic.to.saveApiPrefix(data['ank_apiPrefix']),
      StoreLogic.to.saveH5Prefix(data['ank_h5Prefix']),
      StoreLogic.to.saveDepthOrderDomain(data['newDepthOrderDomain']),
    ]);
    Apis.dio.options.baseUrl = Urls.apiPrefix;
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
