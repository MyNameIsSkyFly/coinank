import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreLogic extends GetxController {
  static StoreLogic get to => Get.find();

  static Future<void> init() async {
    await _SpUtil().init();
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
}

class _SpKeys {
  _SpKeys._();

  static const locale = 'language';
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
