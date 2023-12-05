// ignore_for_file: unused_element

import 'dart:convert';

import 'package:ank_app/constants/app_const.dart';
import 'package:ank_app/entity/event/logged_event.dart';
import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/entity/user_info_entity.dart';
import 'package:ank_app/pigeon/host_api.g.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreLogic extends GetxController {
  static StoreLogic get to => Get.find();

  static bool isLogin = false;

  static Future<void> init() async {
    await _SpUtil().init();
    updateLoginStatus();
  }

  static Future<void> clearUserInfo() async {
    await StoreLogic.to.removeLoginUserInfo();
    await StoreLogic.to.removeLoginPassword();
    await StoreLogic.to.removeLoginUsername();
    MessageHostApi().saveLoginInfo('');
    StoreLogic.updateLoginStatus();
    await CommonWebView.setCookieValue();
    AppConst.eventBus.fire(LoginStatusChangeEvent(isLogin: false));
  }

  static void updateLoginStatus() {
    isLogin = StoreLogic.to.loginUserInfo?.token != null &&
        StoreLogic.to.loginUserInfo!.token!.isNotEmpty;
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

  Future<bool?> saveDarkMode(bool? isDarkMode) {
    return _SpUtil()._saveInt(
        _SpKeys.darkMode,
        isDarkMode == null
            ? -1
            : isDarkMode
                ? 1
                : 0);
  }

  bool? get isDarkMode {
    return switch (_SpUtil()._getInt(_SpKeys.darkMode, defaultValue: -1)) {
      1 => true,
      0 => false,
      _ => null,
    };
  }

  Future<bool> saveUpGreen(bool isUpGreen) {
    return _SpUtil()._saveBool(_SpKeys.upGreen, isUpGreen);
  }

  bool get isUpGreen {
    var isGreen = _SpUtil()._getBool(_SpKeys.upGreen, defaultValue: true);
    return isGreen;
  }

  RxList<MarkerTickerEntity> contractData = RxList.empty();

  void setContractData(List<MarkerTickerEntity> v) {
    contractData.value = v;
  }

  Future<bool> saveLoginPassword(String password) {
    return _SpUtil()._saveString(_SpKeys.loginPassword, password);
  }

  String get loginPassword {
    return _SpUtil()._getString(_SpKeys.loginPassword, defaultValue: '');
  }

  Future<bool> removeLoginPassword() {
    return _SpUtil()._remove(_SpKeys.loginPassword);
  }

  Future<bool> saveLoginUsername(String username) {
    return _SpUtil()._saveString(_SpKeys.loginUsername, username);
  }

  String get loginUsername {
    return _SpUtil()._getString(_SpKeys.loginUsername, defaultValue: '');
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
    var userInfo =
        _SpUtil()._getString(_SpKeys.loginUserInfo, defaultValue: '');
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
    final time = _SpUtil()._getInt(_SpKeys.lastSendCodeTime, defaultValue: 0);
    if (time == 0) return DateTime.fromMillisecondsSinceEpoch(0);
    return DateTime.fromMillisecondsSinceEpoch(time);
  }

  Future<bool> saveDeviceId(String deviceId) {
    return _SpUtil()._saveString(_SpKeys.deviceId, deviceId);
  }

  String get deviceId {
    return _SpUtil()._getString(_SpKeys.deviceId);
  }

  Future<bool> saveChartUrl(String chartUrl) {
    return _SpUtil()._saveString(_SpKeys.chartUrl, chartUrl);
  }

  String get chartUrl {
    return _SpUtil()
        ._getString(_SpKeys.chartUrl, defaultValue: 'assets/files/t18.html');
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
    return _SpUtil()._getString(_SpKeys.domain, defaultValue: 'coinsoto.com');
  }

  Future<bool> saveWebsocketUrl(String websocketUrl) {
    return _SpUtil()._saveString(_SpKeys.websocketUrl, websocketUrl);
  }

  String get websocketUrl {
    return _SpUtil()._getString(_SpKeys.websocketUrl,
        defaultValue: 'wss://coinsoto.com/wsKline/wsKline');
  }

  Future<bool> saveApiPrefix(String apiPrefix) {
    return _SpUtil()._saveString(_SpKeys.apiPrefix, apiPrefix);
  }

  String get apiPrefix {
    return _SpUtil()
        ._getString(_SpKeys.apiPrefix, defaultValue: 'https://coinsoto.com');
  }

  Future<bool> saveH5Prefix(String h5Prefix) {
    return _SpUtil()._saveString(_SpKeys.h5Prefix, h5Prefix);
  }

  String get h5Prefix {
    return _SpUtil()
        ._getString(_SpKeys.h5Prefix, defaultValue: 'https://coinsoto.com');
  }

  //depthOrderDomain
  Future<bool> saveDepthOrderDomain(String depthOrderDomain) {
    return _SpUtil()._saveString(_SpKeys.depthOrderDomain, depthOrderDomain);
  }

  String get depthOrderDomain {
    return _SpUtil()._getString(_SpKeys.depthOrderDomain,
        defaultValue: 'cdn01.coinsoto.com');
  }

  //isFirst
  Future<bool> saveIsFirst(bool isFirst) {
    return _SpUtil()._saveBool(_SpKeys.isFirst, isFirst);
  }

  bool get isFirst {
    return _SpUtil()._getBool(_SpKeys.isFirst, defaultValue: true);
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
  static const chartUrl = 'ank_charturl';
  static const uniappDomain = 'ank_uniappDomain';
  static const domain = 'ank_domain';
  static const websocketUrl = 'ank_websocketUrl';
  static const apiPrefix = 'ank_apiPrefix';
  static const h5Prefix = 'ank_h5Prefix';
  static const depthOrderDomain = 'ank_depthOrderDomain';
  static const isFirst = 'isFirst';
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
