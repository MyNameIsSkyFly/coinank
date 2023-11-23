import 'dart:convert';

import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/entity/user_info_entity.dart';
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

  Future<bool> saveLoginUsername(String username) {
    return _SpUtil()._saveString(_SpKeys.loginUsername, username);
  }

  String get loginUsername {
    return _SpUtil()._getString(_SpKeys.loginUsername, defaultValue: '');
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
