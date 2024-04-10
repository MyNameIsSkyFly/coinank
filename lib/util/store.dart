// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:math';

import 'package:ank_app/entity/event/logged_event.dart';
import 'package:ank_app/entity/order_flow_symbol.dart';
import 'package:ank_app/entity/user_info_entity.dart';
import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entity/chart_entity.dart';
import '../entity/search_v2_entity.dart';

class StoreLogic extends GetxController {
  static StoreLogic get to => _instance;

  static final StoreLogic _instance = StoreLogic._();

  factory StoreLogic() => _instance;

  StoreLogic._();

  static bool isLogin = false;

  static Future<void> init() async {
    await _SpUtil().init();
    updateLoginStatus();
  }

  static Future<void> clearUserInfo() async {
    await to.removeLoginUserInfo();
    // await to.removeLoginPassword();
    // await to.removeLoginUsername();
    MessageHostApi().saveLoginInfo('');
    StoreLogic.updateLoginStatus();
    await CommonWebView.setCookieValue();
    AppConst.eventBus.fire(LoginStatusChangeEvent(isLogin: false));
  }

  static void updateLoginStatus() {
    isLogin =
        to.loginUserInfo?.token != null && to.loginUserInfo!.token!.isNotEmpty;
    Get.forceAppUpdate();
  }

  Future<bool> saveLocale(Locale? locale) {
    final language = switch (locale) {
      Locale(languageCode: 'en') => 0,
      Locale(languageCode: 'zh', scriptCode: 'Hans') => 1,
      Locale(languageCode: 'zh', scriptCode: 'Hant') => 2,
      Locale(languageCode: 'ja') => 3,
      Locale(languageCode: 'ko') => 4,
      _ => -1,
    };
    return _SpUtil()._saveInt(_SpKeys.locale, language);
  }

  Locale? get locale {
    return switch (_SpUtil()._getInt(_SpKeys.locale, defaultValue: -1)) {
      0 => const Locale('en'),
      1 => const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      2 => const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      3 => const Locale('ja'),
      4 => const Locale('ko'),
      _ => null,
    };
  }

  Future<bool?> saveDarkMode(bool? isDarkMode) async {
    return await _SpUtil()._saveInt(
        _SpKeys.darkMode,
        isDarkMode == null
            ? -1
            : isDarkMode
                ? 1
                : 0);
  }

  bool get isDarkMode {
    return switch (_SpUtil()._getInt(_SpKeys.darkMode)) {
      1 => true,
      0 => false,
      _ => false,
    };
  }

  Future<bool> saveUpGreen(bool isUpGreen) {
    return _SpUtil()._saveBool(_SpKeys.upGreen, isUpGreen);
  }

  bool get isUpGreen {
    var isGreen = _SpUtil()._getBool(_SpKeys.upGreen, defaultValue: true);
    return isGreen;
  }

  Future<bool> saveLoginPassword(String password) {
    return _SpUtil()._saveString(_SpKeys.loginPassword, password);
  }

  String get loginPassword {
    return _SpUtil()._getString(_SpKeys.loginPassword);
  }

  Future<bool> removeLoginPassword() {
    return _SpUtil()._remove(_SpKeys.loginPassword);
  }

  Future<bool> saveLoginUsername(String username) {
    return _SpUtil()._saveString(_SpKeys.loginUsername, username);
  }

  String get loginUsername {
    return _SpUtil()._getString(_SpKeys.loginUsername);
  }

  Future<bool> removeLoginUsername() {
    return _SpUtil()._remove(_SpKeys.loginUsername);
  }

  Future<bool> saveLoginUserInfo(UserInfoEntity? userInfo) {
    return _SpUtil()._saveString(_SpKeys.loginUserInfo,
        userInfo == null ? '' : jsonEncode(userInfo.toJson()));
  }

  Future<bool> removeLoginUserInfo() {
    return _SpUtil()._remove(_SpKeys.loginUserInfo);
  }

  UserInfoEntity? get loginUserInfo {
    var userInfo = _SpUtil()._getString(_SpKeys.loginUserInfo);
    if (userInfo.isEmpty) return null;
    return UserInfoEntity.fromJson(
        jsonDecode(userInfo) as Map<String, dynamic>);
  }

  Future<bool> saveLastSendCodeTime() {
    final time = DateTime.now();
    return _SpUtil()
        ._saveInt(_SpKeys.lastSendCodeTime, time.millisecondsSinceEpoch);
  }

  DateTime get lastSendCodeTime {
    final time = _SpUtil()._getInt(_SpKeys.lastSendCodeTime);
    if (time == 0) return DateTime.fromMillisecondsSinceEpoch(0);
    return DateTime.fromMillisecondsSinceEpoch(time);
  }

  Future<bool> saveDeviceId(String deviceId) {
    return _SpUtil()._saveString(_SpKeys.deviceId, deviceId);
  }

  String get deviceId {
    return _SpUtil()._getString(_SpKeys.deviceId);
  }

  static const _chartVersionInDevice = {
    'chart': 2,
    'liqHot': 1,
    'kline': 1,
    'heatmap': 1,
    'cateHeatmap': 1,
    'cateChart': 1
  };

  Future<bool> saveChartVersion(String chartUrl) {
    return _SpUtil()._saveString(_SpKeys.chartVersion, chartUrl);
  }

  bool _chartUseCDN(String type) {
    try {
      var version = _SpUtil()._getString(_SpKeys.chartVersion);
      final chartVersionRemote = {
        for (var e in version.split('/'))
          e.split(':')[0]: int.parse(e.split(':')[1])
      };
      return chartVersionRemote[type]! > _chartVersionInDevice[type]!;
    } catch (e) {
      return true;
    }
  }

  Future<bool> saveChartUrl(String chartUrl) {
    return _SpUtil()._saveString(_SpKeys.chartUrl, chartUrl);
  }

  String get chartUrl {
    return _chartUseCDN('chart')
        ? _SpUtil()
            ._getString(_SpKeys.chartUrl, defaultValue: 'assets/files/t23.html')
        : 'assets/files/t23.html';
  }

  //klineUrl
  Future<bool> saveKlineUrl(String klineUrl) {
    return _SpUtil()._saveString(_SpKeys.klineUrl, klineUrl);
  }

  String get klineUrl {
    return _chartUseCDN('kline')
        ? _SpUtil()
            ._getString(_SpKeys.klineUrl, defaultValue: 'assets/files/k5.html')
        : 'assets/files/k5.html';
  }

  //heatMapUrl
  Future<bool> saveHeatMapUrl(String heatMapUrl) {
    return _SpUtil()._saveString(_SpKeys.heatMapUrl, heatMapUrl);
  }

  String get heatMapUrl {
    return _chartUseCDN('heatmap')
        ? _SpUtil()
            ._getString(_SpKeys.heatMapUrl, defaultValue: 'assets/files/h.html')
        : 'assets/files/h.html';
  }

  //categoryHeatMapUrl
  Future<bool> saveCategoryHeatMapUrl(String? categoryHeatMapUrl) {
    if (categoryHeatMapUrl == null) return Future.value(false);
    return _SpUtil()
        ._saveString(_SpKeys.categoryHeatMapUrl, categoryHeatMapUrl);
  }

  String get categoryHeatMapUrl {
    return _chartUseCDN('cateHeatmap')
        ? _SpUtil()._getString(_SpKeys.categoryHeatMapUrl,
            defaultValue: 'assets/files/category-heatmap.html')
        : 'assets/files/category-heatmap.html';
  }

  //liqHeatMapUrl
  Future<bool> saveLiqHeatMapUrl(String liqHeatMapUrl) {
    return _SpUtil()._saveString(_SpKeys.liqHeatMapUrl, liqHeatMapUrl);
  }

  String get liqHeatMapUrl {
    return _chartUseCDN('liqHot')
        ? _SpUtil()._getString(_SpKeys.liqHeatMapUrl,
            defaultValue: 'assets/files/liqhm.html')
        : 'assets/files/liqhm.html';
  }

  //categoryChartUrl
  Future<bool> saveCategoryChartUrl(String? categoryChartUrl) {
    if (categoryChartUrl == null) return Future.value(false);
    return _SpUtil()._saveString(_SpKeys.categoryChartUrl, categoryChartUrl);
  }

  String get categoryChartUrl {
    return _chartUseCDN('cateChart')
        ? _SpUtil()._getString(_SpKeys.categoryChartUrl,
            defaultValue: 'assets/files/category-chart.html')
        : 'assets/files/category-chart.html';
  }

  Future<bool> saveUniappDomain(String uniappDomain) {
    return _SpUtil()._saveString(_SpKeys.uniappDomain, uniappDomain);
  }

  String get uniappDomain {
    var withoutHttps = _SpUtil()._getString(_SpKeys.uniappDomain,
        defaultValue: 'coinsoto-h5.s3.ap-northeast-1.amazonaws.com');
    return 'https://$withoutHttps';
  }

  Future<bool> saveDomain(String domain) {
    return _SpUtil()._saveString(_SpKeys.domain, domain);
  }

  String get domain {
    return _SpUtil()._getString(_SpKeys.domain, defaultValue: 'coinank.com');
  }

  Future<bool> saveWebsocketUrl(String websocketUrl) {
    return _SpUtil()._saveString(_SpKeys.websocketUrl, websocketUrl);
  }

  String get websocketUrl {
    return _SpUtil()._getString(_SpKeys.websocketUrl,
        defaultValue: 'wss://coinank.com/wsKline/wsKline');
  }

  Future<bool> saveApiPrefix(String apiPrefix) {
    return _SpUtil()._saveString(_SpKeys.apiPrefix, apiPrefix);
  }

  String get apiPrefix {
    return _SpUtil()
        ._getString(_SpKeys.apiPrefix, defaultValue: 'https://coinank.com');
  }

  Future<bool> saveH5Prefix(String h5Prefix) {
    return _SpUtil()._saveString(_SpKeys.h5Prefix, h5Prefix);
  }

  String get h5Prefix {
    return _SpUtil()
        ._getString(_SpKeys.h5Prefix, defaultValue: 'https://coinank.com');
  }

  //depthOrderDomain
  Future<bool> saveDepthOrderDomain(String depthOrderDomain) {
    return _SpUtil()._saveString(_SpKeys.depthOrderDomain, depthOrderDomain);
  }

  String get depthOrderDomain {
    return _SpUtil()._getString(_SpKeys.depthOrderDomain,
        defaultValue: 'cdn01.coinank.com');
  }


  Future<bool> saveRecentChart(ChartEntity recentChart) {
    final original = recentCharts;
    if (original.map((e) => e.key).contains(recentChart.key)) {
      original.removeWhere((element) => element.key == recentChart.key);
      original.insert(0, recentChart);
    } else {
      original.insert(0, recentChart);
    }
    return _SpUtil()._saveStringList(
      _SpKeys.recentChart,
      original
          .map((e) => jsonEncode(e.toJson()))
          .toList()
          .sublist(0, min(original.length, 8)),
    );
  }

  List<ChartEntity> get recentCharts {
    var recentChart =
        _SpUtil()._getStringList(_SpKeys.recentChart, defaultValue: []);
    return recentChart.map((e) => ChartEntity.fromJson(jsonDecode(e))).toList();
  }

  Future<bool> saveWebConfig(String key, String value) {
    return _SpUtil()._saveString('webConfig_$key', value);
  }

  String webConfig(String key) {
    return _SpUtil()._getString('webConfig_$key');
  }

  Future<bool> saveFavoriteContract(String baseCoin) {
    final original = favoriteContract.toList();
    if (original.contains(baseCoin)) {
      return Future.value(true);
    } else {
      original.add(baseCoin);
    }
    return _SpUtil()._saveStringList(_SpKeys.favoriteContract, original);
  }

  Future<bool> removeFavoriteContract(String baseCoin) {
    final original = favoriteContract;
    if (!original.contains(baseCoin)) {
      return Future.value(true);
    } else {
      original.remove(baseCoin);
    }
    return _SpUtil()._saveStringList(_SpKeys.favoriteContract, original);
  }

  List<String> get favoriteContract {
    return _SpUtil()._getStringList(_SpKeys.favoriteContract, defaultValue: []);
  }

  Future<bool> saveFavoriteSpot(String baseCoin) {
    final original = favoriteSpot.toList();
    if (original.contains(baseCoin)) {
      return Future.value(true);
    } else {
      original.add(baseCoin);
    }
    return _SpUtil()._saveStringList(_SpKeys.favoriteSpot, original);
  }

  Future<bool> removeFavoriteSpot(String baseCoin) {
    final original = favoriteSpot;
    if (!original.contains(baseCoin)) {
      return Future.value(true);
    } else {
      original.remove(baseCoin);
    }
    return _SpUtil()._saveStringList(_SpKeys.favoriteSpot, original);
  }

  List<String> get favoriteSpot {
    return _SpUtil()._getStringList(_SpKeys.favoriteSpot, defaultValue: []);
  }

  //===========================tappedSearchResult===================================================================
  Future<bool> saveTappedSearchResult(SearchV2ItemEntity entity) {
    final original = tappedSearchResult;
    if (original.contains(entity)) {
      original.remove(entity);
      original.insert(0, entity);
    } else {
      original.insert(0, entity);
    }
    return _SpUtil()._saveStringList(
      _SpKeys.tappedSearchResult,
      original
          .map((e) => jsonEncode(e.toJson()))
          .toList()
          .sublist(0, min(original.length, 10)),
    );
  }

  Future<bool> clearTappedSearchResult() {
    return _SpUtil()._remove(_SpKeys.tappedSearchResult);
  }

  List<SearchV2ItemEntity> get tappedSearchResult {
    final stringList =
        _SpUtil()._getStringList(_SpKeys.tappedSearchResult, defaultValue: []);
    return stringList
        .map((e) => SearchV2ItemEntity.fromJson(jsonDecode(e)))
        .toList();
  }

  //orderFlowSymbolsJson
  Future<bool> saveOrderFlowSymbolsJson(
      List<OrderFlowSymbolEntity> orderFlowSymbolsJson) {
    return _SpUtil()._saveStringList(_SpKeys.orderFlowSymbolsJson,
        orderFlowSymbolsJson.map((e) => jsonEncode(e.toJson())).toList());
  }

  List<OrderFlowSymbolEntity> get orderFlowSymbolsJson {
    final result = _SpUtil()._getStringList(_SpKeys.orderFlowSymbolsJson);
    return result
        .map((e) => OrderFlowSymbolEntity.fromJson(jsonDecode(e)))
        .toList();
  }

  //contractCoinSortOrder
  Future<bool> saveContractCoinSortOrder(Map<String, bool> sortOrder) {
    return _SpUtil()
        ._saveString(_SpKeys.contractCoinSortOrder, jsonEncode(sortOrder));
  }

  Map<String, bool> get contractCoinSortOrder {
    final result = _SpUtil()._getString(_SpKeys.contractCoinSortOrder,
        defaultValue:
            '{"price":true,"priceChangeH24":true,"openInterest":true,"openInterestCh24":true,"turnover24h":true,"fundingRate":true,"priceChangeH1":false,"priceChangeH4":false,"priceChangeH6":false,"priceChangeH12":false,"openInterestChM5":false,"openInterestChM15":false,"openInterestChM30":false,"openInterestCh1":false,"openInterestCh4":false,"openInterestCh2D":false,"openInterestCh3D":false,"openInterestCh7D":false,"liquidationH1":false,"liquidationH4":false,"liquidationH12":false,"liquidationH24":false,"longShortRatio":false,"longShortPerson":false,"lsPersonChg5m":false,"lsPersonChg15m":false,"lsPersonChg30m":false,"lsPersonChg1h":false,"lsPersonChg4h":false,"longShortPosition":false,"longShortAccount":false,"marketCap":true,"marketCapChange24H":false,"circulatingSupply":false,"totalSupply":false,"maxSupply":false}');
    // ignore: avoid_dynamic_calls
    return jsonDecode(result).cast<String, bool>();
  }

  Future<bool> removeContractCoinSortOrder() {
    return _SpUtil()._remove(_SpKeys.contractCoinSortOrder);
  }

  Future<bool> saveSpotSortOrder(Map<String, bool> sortOrder) {
    return _SpUtil()._saveString(_SpKeys.spotSortOrder, jsonEncode(sortOrder));
  }

  Map<String, bool> get spotSortOrder {
    final result = _SpUtil()._getString(_SpKeys.spotSortOrder,
        defaultValue:
            '{"price":true,"priceChangeH24":true,"turnover24h":true,"turnoverChg24h":true,"priceChangeM5":false,"priceChangeM15":false,"priceChangeM30":false,"priceChangeH1":true,"priceChangeH4":true,"priceChangeH8":true,"priceChangeH12":false,"marketCap":true,"marketCapChange24H":false,"circulatingSupply":false,"totalSupply":true,"maxSupply":false}');
    // ignore: avoid_dynamic_calls
    return jsonDecode(result).cast<String, bool>();
  }

  Future<bool> removeSpotSortOrder() {
    return _SpUtil()._remove(_SpKeys.spotSortOrder);
  }

  //contractCoinFilter
  Future<bool> saveContractCoinFilter(Map<String, String?> filter) {
    return _SpUtil()
        ._saveString(_SpKeys.contractCoinFilter, jsonEncode(filter));
  }

  Map<String, String>? get contractCoinFilter {
    final result = _SpUtil()._getString(_SpKeys.contractCoinFilter);
    if (result.isEmpty || result == '{}') return null;
    // ignore: avoid_dynamic_calls
    return jsonDecode(result).cast<String, String>();
  }

//spotCoinFilter
  Future<bool> saveSpotCoinFilter(Map<String, String?> filter) {
    return _SpUtil()._saveString(_SpKeys.spotCoinFilter, jsonEncode(filter));
  }

  Map<String, String>? get spotCoinFilter {
    final result = _SpUtil()._getString(_SpKeys.spotCoinFilter);
    if (result.isEmpty || result == '{}') return null;
    // ignore: avoid_dynamic_calls
    return jsonDecode(result).cast<String, String>();
  }

  //contractCoinFilterCategory
  Future<bool> saveContractCoinFilterCategory(Map<String, String?> filter) {
    return _SpUtil()
        ._saveString(_SpKeys.contractCoinFilterCategory, jsonEncode(filter));
  }

  Map<String, String>? get contractCoinFilterCategory {
    final result = _SpUtil()._getString(_SpKeys.contractCoinFilterCategory);
    if (result.isEmpty || result == '{}') return null;
    // ignore: avoid_dynamic_calls
    return jsonDecode(result).cast<String, String>();
  }

//spotCoinFilterCategory
  Future<bool> saveSpotCoinFilterCategory(Map<String, String?> filter) {
    return _SpUtil()
        ._saveString(_SpKeys.spotCoinFilterCategory, jsonEncode(filter));
  }

  Map<String, String>? get spotCoinFilterCategory {
    final result = _SpUtil()._getString(_SpKeys.spotCoinFilterCategory);
    if (result.isEmpty || result == '{}') return null;
    // ignore: avoid_dynamic_calls
    return jsonDecode(result).cast<String, String>();
  }

  Future<bool> saveCategoryContractOrder(Map<String, bool> sortOrder) {
    return _SpUtil()
        ._saveString(_SpKeys.categoryContractOrder, jsonEncode(sortOrder));
  }

  Map<String, bool> get categoryContractOrder {
    final result = _SpUtil()._getString(_SpKeys.categoryContractOrder,
        defaultValue:
            '{"price":true,"priceChangeH24":true,"openInterest":true,"openInterestCh24":true,"turnover24h":true,"fundingRate":true,"priceChangeH1":false,"priceChangeH4":false,"priceChangeH6":false,"priceChangeH12":false,"openInterestChM5":false,"openInterestChM15":false,"openInterestChM30":false,"openInterestCh1":false,"openInterestCh4":false,"openInterestCh2D":false,"openInterestCh3D":false,"openInterestCh7D":false,"liquidationH1":false,"liquidationH4":false,"liquidationH12":false,"liquidationH24":false,"longShortRatio":false,"longShortPerson":false,"lsPersonChg5m":false,"lsPersonChg15m":false,"lsPersonChg30m":false,"lsPersonChg1h":false,"lsPersonChg4h":false,"longShortPosition":false,"longShortAccount":false,"marketCap":true,"marketCapChange24H":false,"circulatingSupply":false,"totalSupply":false,"maxSupply":false}');
    // ignore: avoid_dynamic_calls
    return jsonDecode(result).cast<String, bool>();
  }

  Future<bool> removeCategoryContractOrder() {
    return _SpUtil()._remove(_SpKeys.categoryContractOrder);
  }

  Future<bool> saveCategorySpotOrder(Map<String, bool> sortOrder) {
    return _SpUtil()
        ._saveString(_SpKeys.categorySpotOrder, jsonEncode(sortOrder));
  }

  Map<String, bool> get categorySpotOrder {
    final result = _SpUtil()._getString(_SpKeys.categorySpotOrder,
        defaultValue:
            '{"price":true,"priceChangeH24":true,"turnover24h":true,"turnoverChg24h":true,"priceChangeM5":false,"priceChangeM15":false,"priceChangeM30":false,"priceChangeH1":true,"priceChangeH4":true,"priceChangeH8":true,"priceChangeH12":false,"marketCap":true,"marketCapChange24H":false,"circulatingSupply":false,"totalSupply":true,"maxSupply":false}');
    // ignore: avoid_dynamic_calls
    return jsonDecode(result).cast<String, bool>();
  }

  Future<bool> removeCategorySpotOrder() {
    return _SpUtil()._remove(_SpKeys.categorySpotOrder);
  }

  //orderflowCoinSelectorIndex
  Future<bool> saveOrderflowCoinSelectorIndex(int index) {
    return _SpUtil()._saveInt(_SpKeys.orderflowCoinSelectorIndex, index);
  }

  int get orderflowCoinSelectorIndex {
    return _SpUtil()
        ._getInt(_SpKeys.orderflowCoinSelectorIndex, defaultValue: 1);
  }
}

class _SpKeys {
  _SpKeys._();

  static const locale = 'locale';

  ///是否深色主题
  static const darkMode = 'darkMode';

  ///是否绿色为涨
  static const upGreen = 'upGreen';
  static const loginPassword = 'loginPassword';
  static const loginUsername = 'loginUsername';
  static const loginUserInfo = 'loginUserInfo';
  static const lastSendCodeTime = 'lastSendCodeTime';

  static const deviceId = 'deviceId';
  static const chartVersion = 'ank_chart_version';
  static const chartUrl = 'ank_charturl';
  static const klineUrl = 'ank_kline_url';
  static const heatMapUrl = 'ank_heatmap_url';
  static const categoryHeatMapUrl = 'ank_category_heatmap_url';
  static const liqHeatMapUrl = 'ank_liq_heatmap_url';
  static const categoryChartUrl = 'ank_category_chart_url';
  static const uniappDomain = 'ank_uniappDomain';
  static const domain = 'ank_domain';
  static const websocketUrl = 'ank_websocketUrl';
  static const apiPrefix = 'ank_apiPrefix';
  static const h5Prefix = 'ank_h5Prefix';
  static const depthOrderDomain = 'ank_depthOrderDomain';
  static const isFirst = 'isFirst';
  static const recentChart = 'recentChart';
  static const favoriteContract = 'favoriteContract';
  static const favoriteSpot = 'favoriteSpot';
  static const tappedSearchResult = 'tappedSearchResult';
  static const orderFlowSymbolsJson = 'orderFlowSymbolsJson';
  static const contractCoinSortOrder = 'contractCoinSortOrder';
  static const spotSortOrder = 'spotCoinSortOrder';
  static const contractCoinFilter = 'contractCoinFilter';
  static const spotCoinFilter = 'spotCoinFilter';
  static const contractCoinFilterCategory = 'contractCoinFilterCategory';
  static const spotCoinFilterCategory = 'spotCoinFilterCategory';
  static const categoryContractOrder = 'categoryContractOrder';
  static const categorySpotOrder = 'categorySpotOrder';
  static const orderflowCoinSelectorIndex = 'orderflowCoinSelectorIndex';
}

class _SpUtil {
  static final _SpUtil _instance = _SpUtil._();
  SharedPreferences? _preferences;

  factory _SpUtil() => _instance;

  _SpUtil._();

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<bool> _saveString(String key, String value) async {
    return await _preferences?.setString(key, value) ?? false;
  }

  String _getString(String key, {String defaultValue = ''}) {
    return _preferences?.getString(key) ?? defaultValue;
  }

  Future<bool> _saveBool(String key, bool value) async {
    return await _preferences?.setBool(key, value) ?? false;
  }

  bool _getBool(String key, {bool defaultValue = false}) {
    return _preferences?.getBool(key) ?? defaultValue;
  }

  Future<bool> _saveInt(String key, int value) async {
    return await _preferences?.setInt(key, value) ?? false;
  }

  int _getInt(String key, {int defaultValue = 0}) {
    return _preferences?.getInt(key) ?? defaultValue;
  }

  Future<bool> _saveDouble(String key, double value) async {
    return await _preferences?.setDouble(key, value) ?? false;
  }

  double _getDouble(String key, {double defaultValue = 0.0}) {
    return _preferences?.getDouble(key) ?? defaultValue;
  }

  Future<bool> _saveStringList(String key, List<String> value) async {
    return await _preferences?.setStringList(key, value) ?? false;
  }

  List<String> _getStringList(String key,
      {List<String> defaultValue = const []}) {
    return _preferences?.getStringList(key) ?? defaultValue;
  }

  Future<bool> _remove(String key) async {
    return await _preferences?.remove(key) ?? false;
  }

  Future<bool> _clear() async {
    return await _preferences?.clear() ?? false;
  }

  Future<void> _reload() async {
    return await _preferences?.reload();
  }
}
