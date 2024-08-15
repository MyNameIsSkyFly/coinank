// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/util/http_adapter/_http_adapter_api.dart'
    if (dart.library.io) 'package:ank_app/util/http_adapter/_http_adapter_io.dart'
    if (dart.library.html) 'package:ank_app/util/http_adapter/_http_adapter_html.dart'
    as native_adapter;
import 'package:ank_app/widget/common_webview.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../constants/urls.dart';

class Application {
  Application._();

  static final Application _instance = Application._();

  static Application get instance {
    return _instance;
  }

  Future<void> init() async {
    await Future.wait([StoreLogic.init(), _checkNetwork(), _initPackageInfo()]);
    MessageFlutterApi.setUp(FlutterApiManager());
    // material_indicator.dart 中修改以解决rebuild的问题
    // double? get _value 中添加:
    // if (_mode == IndicatorMode.inactive) return 0;
    initLoading();
    ImageUtil.init();
    await CommonWebView.setCookieValue();
    if (!kIsWeb && Platform.isAndroid) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
    PlatformInAppWebViewController.debugLoggingSettings =
        DebugLoggingSettings(enabled: false);
    initConfig();
    if (Platform.isAndroid) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> _initPackageInfo() async {
    AppConst.packageInfo = await PackageInfo.fromPlatform();
    if (!kIsWeb && Platform.isAndroid) {
      AppConst.deviceInfo = await DeviceInfoPlugin().androidInfo;
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

  Future<void> initConfig() async {
    await getConfig();
  }

  Future<bool> getConfig() async {
    final result = await (Dio()
          ..httpClientAdapter = native_adapter.getNativeAdapter())
        .get('https://coinsoho.s3.us-east-2.amazonaws.com/app/config.txt')
        .catchError((e) {
      return Response(requestOptions: RequestOptions());
    });
    if (result.statusCode != 200) return false;
    final data = jsonDecode(result.data)['data'];

    await Future.wait([
      StoreLogic.to.saveChartVersion(data['ank_chart_version']),
      StoreLogic.to.saveChartUrl(data['ank_charturl']),
      StoreLogic.to.saveKlineUrl(data['ank_kline_url']),
      StoreLogic.to.saveHeatMapUrl(data['ank_heatmap_url']),
      StoreLogic.to.saveCategoryHeatMapUrl(data['ank_category_heatmap_url']),
      StoreLogic.to.saveCategoryChartUrl(data['ank_category_chart_url']),
      StoreLogic.to.saveLiqHeatMapUrl(data['ank_liq_hot_chart']),
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

  Future<void> _checkNetwork() async {
    final connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();
    AppConst.networkConnected = result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.other);
  }

  static void setSystemUiMode({bool fullscreen = false}) {
    if (fullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.top]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }
}

class FlutterApiManager extends MessageFlutterApi {
  @override
  void toKLine(String exchangeName, String symbol, String baseCoin,
      String? productType) {
    AppUtil.toKLine(exchangeName, symbol, baseCoin, productType);
  }
}
