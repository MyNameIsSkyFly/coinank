// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  // skipped getter for the '用户名不存在' key

  // skipped getter for the '请求超时' key

  // skipped getter for the '网络连接失败' key

  // skipped getter for the '密码错误' key

  // skipped getter for the '登录成功' key

  // skipped getter for the '请输入正确的邮箱地址' key

  // skipped getter for the '密码格式不正确' key

  // skipped getter for the '发送成功' key

  // skipped getter for the '重新获取' key

  // skipped getter for the '验证码格式错误' key

  // skipped getter for the '此邮箱已注册' key

  // skipped getter for the '验证码错误' key

  // skipped getter for the '注册成功' key

  /// `fragment`
  String get s_fragment {
    return Intl.message(
      'fragment',
      name: 's_fragment',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get s_refresh {
    return Intl.message(
      'Refresh',
      name: 's_refresh',
      desc: '',
      args: [],
    );
  }

  /// `fast open`
  String get s_fast_open {
    return Intl.message(
      'fast open',
      name: 's_fast_open',
      desc: '',
      args: [],
    );
  }

  /// `KLine`
  String get s_kline {
    return Intl.message(
      'KLine',
      name: 's_kline',
      desc: '',
      args: [],
    );
  }

  /// `Float window`
  String get s_float_view {
    return Intl.message(
      'Float window',
      name: 's_float_view',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get s_more_time {
    return Intl.message(
      'More',
      name: 's_more_time',
      desc: '',
      args: [],
    );
  }

  /// `24h High`
  String get s_24h_max_price {
    return Intl.message(
      '24h High',
      name: 's_24h_max_price',
      desc: '',
      args: [],
    );
  }

  /// `24h Low`
  String get s_24h_min_price {
    return Intl.message(
      '24h Low',
      name: 's_24h_min_price',
      desc: '',
      args: [],
    );
  }

  /// `24h Vol`
  String get s_24h_vol {
    return Intl.message(
      '24h Vol',
      name: 's_24h_vol',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get s_minute_time {
    return Intl.message(
      'Time',
      name: 's_minute_time',
      desc: '',
      args: [],
    );
  }

  /// `Indic..`
  String get s_kline_indicator {
    return Intl.message(
      'Indic..',
      name: 's_kline_indicator',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get s_setting {
    return Intl.message(
      'Setting',
      name: 's_setting',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get s_loading {
    return Intl.message(
      'Loading...',
      name: 's_loading',
      desc: '',
      args: [],
    );
  }

  /// `no data`
  String get s_none_data {
    return Intl.message(
      'no data',
      name: 's_none_data',
      desc: '',
      args: [],
    );
  }

  /// `auth failure`
  String get s_auth_failure {
    return Intl.message(
      'auth failure',
      name: 's_auth_failure',
      desc: '',
      args: [],
    );
  }

  /// `auth success`
  String get s_auth_success {
    return Intl.message(
      'auth success',
      name: 's_auth_success',
      desc: '',
      args: [],
    );
  }

  /// `auth please`
  String get s_auth_none {
    return Intl.message(
      'auth please',
      name: 's_auth_none',
      desc: '',
      args: [],
    );
  }

  /// `Setting theme`
  String get s_setting_theme {
    return Intl.message(
      'Setting theme',
      name: 's_setting_theme',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get s_home {
    return Intl.message(
      'Home',
      name: 's_home',
      desc: '',
      args: [],
    );
  }

  /// `Chart`
  String get s_chart {
    return Intl.message(
      'Chart',
      name: 's_chart',
      desc: '',
      args: [],
    );
  }

  /// `OI`
  String get s_oi {
    return Intl.message(
      'OI',
      name: 's_oi',
      desc: '',
      args: [],
    );
  }

  /// `Floating Window`
  String get s_floatviewsetting {
    return Intl.message(
      'Floating Window',
      name: 's_floatviewsetting',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get s_themesetting {
    return Intl.message(
      'Appearance',
      name: 's_themesetting',
      desc: '',
      args: [],
    );
  }

  /// `Color Preference`
  String get s_klinecolor {
    return Intl.message(
      'Color Preference',
      name: 's_klinecolor',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get s_language {
    return Intl.message(
      'Language',
      name: 's_language',
      desc: '',
      args: [],
    );
  }

  /// `Launch Screen`
  String get s_default_home {
    return Intl.message(
      'Launch Screen',
      name: 's_default_home',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get s_conditions_of_privacy {
    return Intl.message(
      'Privacy Policy',
      name: 's_conditions_of_privacy',
      desc: '',
      args: [],
    );
  }

  /// `About US`
  String get s_about_us {
    return Intl.message(
      'About US',
      name: 's_about_us',
      desc: '',
      args: [],
    );
  }

  /// `Check for update`
  String get s_check_update {
    return Intl.message(
      'Check for update',
      name: 's_check_update',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get s_theme_light {
    return Intl.message(
      'Light',
      name: 's_theme_light',
      desc: '',
      args: [],
    );
  }

  /// `Night`
  String get s_theme_night {
    return Intl.message(
      'Night',
      name: 's_theme_night',
      desc: '',
      args: [],
    );
  }

  /// `Red+ Green-`
  String get s_red_up {
    return Intl.message(
      'Red+ Green-',
      name: 's_red_up',
      desc: '',
      args: [],
    );
  }

  /// `Green+ Red-`
  String get s_green_up {
    return Intl.message(
      'Green+ Red-',
      name: 's_green_up',
      desc: '',
      args: [],
    );
  }

  /// `Add Market`
  String get s_add_market {
    return Intl.message(
      'Add Market',
      name: 's_add_market',
      desc: '',
      args: [],
    );
  }

  /// `Floating Display`
  String get s_floatview_display {
    return Intl.message(
      'Floating Display',
      name: 's_floatview_display',
      desc: '',
      args: [],
    );
  }

  /// `Floating Locking`
  String get s_floatview_lock {
    return Intl.message(
      'Floating Locking',
      name: 's_floatview_lock',
      desc: '',
      args: [],
    );
  }

  /// `Add up to 6`
  String get s_add_up_6 {
    return Intl.message(
      'Add up to 6',
      name: 's_add_up_6',
      desc: '',
      args: [],
    );
  }

  /// `perpetual`
  String get s_swap {
    return Intl.message(
      'perpetual',
      name: 's_swap',
      desc: '',
      args: [],
    );
  }

  /// `week`
  String get s_thisweek {
    return Intl.message(
      'week',
      name: 's_thisweek',
      desc: '',
      args: [],
    );
  }

  /// `Bi-week`
  String get s_nextweek {
    return Intl.message(
      'Bi-week',
      name: 's_nextweek',
      desc: '',
      args: [],
    );
  }

  /// `quarter`
  String get s_quarter {
    return Intl.message(
      'quarter',
      name: 's_quarter',
      desc: '',
      args: [],
    );
  }

  /// `Bi-quarter`
  String get s_nextquarter {
    return Intl.message(
      'Bi-quarter',
      name: 's_nextquarter',
      desc: '',
      args: [],
    );
  }

  /// `future`
  String get s_futures {
    return Intl.message(
      'future',
      name: 's_futures',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get s_all {
    return Intl.message(
      'All',
      name: 's_all',
      desc: '',
      args: [],
    );
  }

  /// `search`
  String get s_search {
    return Intl.message(
      'search',
      name: 's_search',
      desc: '',
      args: [],
    );
  }

  /// `Load error, Please retry`
  String get s_load_failure {
    return Intl.message(
      'Load error, Please retry',
      name: 's_load_failure',
      desc: '',
      args: [],
    );
  }

  /// `Main`
  String get s_main_chart {
    return Intl.message(
      'Main',
      name: 's_main_chart',
      desc: '',
      args: [],
    );
  }

  /// `Sub`
  String get s_sub_chart {
    return Intl.message(
      'Sub',
      name: 's_sub_chart',
      desc: '',
      args: [],
    );
  }

  /// `Index Setting`
  String get s_indic_setting {
    return Intl.message(
      'Index Setting',
      name: 's_indic_setting',
      desc: '',
      args: [],
    );
  }

  /// `Press again to exit Coinsoho`
  String get s_doubleclick_exit {
    return Intl.message(
      'Press again to exit Coinsoho',
      name: 's_doubleclick_exit',
      desc: '',
      args: [],
    );
  }

  /// `Please input `
  String get s_input_error {
    return Intl.message(
      'Please input ',
      name: 's_input_error',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get s_reset {
    return Intl.message(
      'Reset',
      name: 's_reset',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get s_confirm {
    return Intl.message(
      'Confirm',
      name: 's_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Calculating Period`
  String get s_calc_period {
    return Intl.message(
      'Calculating Period',
      name: 's_calc_period',
      desc: '',
      args: [],
    );
  }

  /// `Short Period`
  String get s_short_period {
    return Intl.message(
      'Short Period',
      name: 's_short_period',
      desc: '',
      args: [],
    );
  }

  /// `Long Period`
  String get s_long_period {
    return Intl.message(
      'Long Period',
      name: 's_long_period',
      desc: '',
      args: [],
    );
  }

  /// `MA Period`
  String get s_ma_period {
    return Intl.message(
      'MA Period',
      name: 's_ma_period',
      desc: '',
      args: [],
    );
  }

  /// `Bandwidth`
  String get s_bandwidth {
    return Intl.message(
      'Bandwidth',
      name: 's_bandwidth',
      desc: '',
      args: [],
    );
  }

  /// `Floating window is running`
  String get s_floating_notify {
    return Intl.message(
      'Floating window is running',
      name: 's_floating_notify',
      desc: '',
      args: [],
    );
  }

  /// `#123456`
  String get s_test {
    return Intl.message(
      '#123456',
      name: 's_test',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get s_open {
    return Intl.message(
      'Open',
      name: 's_open',
      desc: '',
      args: [],
    );
  }

  /// `High`
  String get s_high {
    return Intl.message(
      'High',
      name: 's_high',
      desc: '',
      args: [],
    );
  }

  /// `Low`
  String get s_low {
    return Intl.message(
      'Low',
      name: 's_low',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get s_close {
    return Intl.message(
      'Close',
      name: 's_close',
      desc: '',
      args: [],
    );
  }

  /// `Chg`
  String get s_chg {
    return Intl.message(
      'Chg',
      name: 's_chg',
      desc: '',
      args: [],
    );
  }

  /// `Ampl`
  String get s_ampl {
    return Intl.message(
      'Ampl',
      name: 's_ampl',
      desc: '',
      args: [],
    );
  }

  /// `Vol`
  String get s_vol {
    return Intl.message(
      'Vol',
      name: 's_vol',
      desc: '',
      args: [],
    );
  }

  /// `Txn`
  String get s_txn {
    return Intl.message(
      'Txn',
      name: 's_txn',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get s_register {
    return Intl.message(
      'Register',
      name: 's_register',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get s_login {
    return Intl.message(
      'Sign In',
      name: 's_login',
      desc: '',
      args: [],
    );
  }

  /// `Input email address`
  String get s_enter_account {
    return Intl.message(
      'Input email address',
      name: 's_enter_account',
      desc: '',
      args: [],
    );
  }

  /// `Email verification code`
  String get s_verify_code {
    return Intl.message(
      'Email verification code',
      name: 's_verify_code',
      desc: '',
      args: [],
    );
  }

  /// `Enter password`
  String get s_enter_password {
    return Intl.message(
      'Enter password',
      name: 's_enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Send verification code`
  String get s_send_verify_code {
    return Intl.message(
      'Send verification code',
      name: 's_send_verify_code',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get s_forget_passwd {
    return Intl.message(
      'Forgot Password',
      name: 's_forget_passwd',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get s_change_password {
    return Intl.message(
      'Change Password',
      name: 's_change_password',
      desc: '',
      args: [],
    );
  }

  /// `Input old password`
  String get s_enter_old_password {
    return Intl.message(
      'Input old password',
      name: 's_enter_old_password',
      desc: '',
      args: [],
    );
  }

  /// `Input new password`
  String get s_enter_new_password {
    return Intl.message(
      'Input new password',
      name: 's_enter_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the correct email address`
  String get s_valid_emailaddress {
    return Intl.message(
      'Please enter the correct email address',
      name: 's_valid_emailaddress',
      desc: '',
      args: [],
    );
  }

  /// `Verification code error`
  String get s_verify_code_error {
    return Intl.message(
      'Verification code error',
      name: 's_verify_code_error',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password format`
  String get s_valid_password {
    return Intl.message(
      'Incorrect password format',
      name: 's_valid_password',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get s_account {
    return Intl.message(
      'User',
      name: 's_account',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get s_exit_login {
    return Intl.message(
      'Logout',
      name: 's_exit_login',
      desc: '',
      args: [],
    );
  }

  /// `Disclaimer`
  String get s_disclaimer {
    return Intl.message(
      'Disclaimer',
      name: 's_disclaimer',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get s_favorite {
    return Intl.message(
      'Favorites',
      name: 's_favorite',
      desc: '',
      args: [],
    );
  }

  /// `Liquidation Data`
  String get s_liquidation_data {
    return Intl.message(
      'Liquidation Data',
      name: 's_liquidation_data',
      desc: '',
      args: [],
    );
  }

  /// `BTC Open Interest`
  String get s_btc_oi {
    return Intl.message(
      'BTC Open Interest',
      name: 's_btc_oi',
      desc: '',
      args: [],
    );
  }

  /// `Open Interest`
  String get s_open_interest {
    return Intl.message(
      'Open Interest',
      name: 's_open_interest',
      desc: '',
      args: [],
    );
  }

  /// `Fear and Greed`
  String get s_greed_index {
    return Intl.message(
      'Fear and Greed',
      name: 's_greed_index',
      desc: '',
      args: [],
    );
  }

  /// `Longs VS Shorts`
  String get s_longshort_ratio {
    return Intl.message(
      'Longs VS Shorts',
      name: 's_longshort_ratio',
      desc: '',
      args: [],
    );
  }

  /// `Funding Rate`
  String get s_funding_rate {
    return Intl.message(
      'Funding Rate',
      name: 's_funding_rate',
      desc: '',
      args: [],
    );
  }

  /// `Exchange`
  String get s_exchange_name {
    return Intl.message(
      'Exchange',
      name: 's_exchange_name',
      desc: '',
      args: [],
    );
  }

  /// `Rate`
  String get s_rate {
    return Intl.message(
      'Rate',
      name: 's_rate',
      desc: '',
      args: [],
    );
  }

  /// `Longs`
  String get s_longs {
    return Intl.message(
      'Longs',
      name: 's_longs',
      desc: '',
      args: [],
    );
  }

  /// `Shorts`
  String get s_shorts {
    return Intl.message(
      'Shorts',
      name: 's_shorts',
      desc: '',
      args: [],
    );
  }

  /// `USDT or USD`
  String get s_usdt_funding {
    return Intl.message(
      'USDT or USD',
      name: 's_usdt_funding',
      desc: '',
      args: [],
    );
  }

  /// `Coin`
  String get s_coin_funding {
    return Intl.message(
      'Coin',
      name: 's_coin_funding',
      desc: '',
      args: [],
    );
  }

  /// `Rekt`
  String get s_rekt {
    return Intl.message(
      'Rekt',
      name: 's_rekt',
      desc: '',
      args: [],
    );
  }

  /// `1h Rekt`
  String get s_1hrekt {
    return Intl.message(
      '1h Rekt',
      name: 's_1hrekt',
      desc: '',
      args: [],
    );
  }

  /// `4h Rekt`
  String get s_4hrekt {
    return Intl.message(
      '4h Rekt',
      name: 's_4hrekt',
      desc: '',
      args: [],
    );
  }

  /// `24h Rekt`
  String get s_24hrekt {
    return Intl.message(
      '24h Rekt',
      name: 's_24hrekt',
      desc: '',
      args: [],
    );
  }

  /// `4h Chg`
  String get s_4h_chg {
    return Intl.message(
      '4h Chg',
      name: 's_4h_chg',
      desc: '',
      args: [],
    );
  }

  /// `Fear`
  String get s_fear {
    return Intl.message(
      'Fear',
      name: 's_fear',
      desc: '',
      args: [],
    );
  }

  /// `Greed`
  String get s_greed {
    return Intl.message(
      'Greed',
      name: 's_greed',
      desc: '',
      args: [],
    );
  }

  /// `Extreme Fear`
  String get s_extreme_fear {
    return Intl.message(
      'Extreme Fear',
      name: 's_extreme_fear',
      desc: '',
      args: [],
    );
  }

  /// `Extreme Greed`
  String get s_extreme_greed {
    return Intl.message(
      'Extreme Greed',
      name: 's_extreme_greed',
      desc: '',
      args: [],
    );
  }

  /// `OI`
  String get s_oi_vol {
    return Intl.message(
      'OI',
      name: 's_oi_vol',
      desc: '',
      args: [],
    );
  }

  /// `24h Vol`
  String get s_24h_turnover {
    return Intl.message(
      '24h Vol',
      name: 's_24h_turnover',
      desc: '',
      args: [],
    );
  }

  /// `没有内容，刷新一下吧~`
  String get has_no_data {
    return Intl.message(
      '没有内容，刷新一下吧~',
      name: 'has_no_data',
      desc: '',
      args: [],
    );
  }

  /// `Pull To Refresh`
  String get pull_to_refresh {
    return Intl.message(
      'Pull To Refresh',
      name: 'pull_to_refresh',
      desc: '',
      args: [],
    );
  }

  /// `Release To Refresh`
  String get release_to_refresh {
    return Intl.message(
      'Release To Refresh',
      name: 'release_to_refresh',
      desc: '',
      args: [],
    );
  }

  /// `Refreshing`
  String get refreshing {
    return Intl.message(
      'Refreshing',
      name: 'refreshing',
      desc: '',
      args: [],
    );
  }

  /// `Refresh Succeeded`
  String get refresh_succeeded {
    return Intl.message(
      'Refresh Succeeded',
      name: 'refresh_succeeded',
      desc: '',
      args: [],
    );
  }

  /// `Refresh Failed`
  String get refresh_failed {
    return Intl.message(
      'Refresh Failed',
      name: 'refresh_failed',
      desc: '',
      args: [],
    );
  }

  /// `Pull Up To Load`
  String get pull_up_to_load {
    return Intl.message(
      'Pull Up To Load',
      name: 'pull_up_to_load',
      desc: '',
      args: [],
    );
  }

  /// `Release To Load`
  String get release_to_load {
    return Intl.message(
      'Release To Load',
      name: 'release_to_load',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Load Succeeded`
  String get load_succeeded {
    return Intl.message(
      'Load Succeeded',
      name: 'load_succeeded',
      desc: '',
      args: [],
    );
  }

  /// `Load Failed`
  String get load_failed {
    return Intl.message(
      'Load Failed',
      name: 'load_failed',
      desc: '',
      args: [],
    );
  }

  /// `cus resources`
  String get customize_resources {
    return Intl.message(
      'cus resources',
      name: 'customize_resources',
      desc: '',
      args: [],
    );
  }

  /// `Markets`
  String get s_tickers {
    return Intl.message(
      'Markets',
      name: 's_tickers',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get s_price {
    return Intl.message(
      'Price',
      name: 's_price',
      desc: '',
      args: [],
    );
  }

  /// `Price Change`
  String get s_price_chg {
    return Intl.message(
      'Price Change',
      name: 's_price_chg',
      desc: '',
      args: [],
    );
  }

  /// `OI Change`
  String get s_oi_chg {
    return Intl.message(
      'OI Change',
      name: 's_oi_chg',
      desc: '',
      args: [],
    );
  }

  /// `Exchange Longs/Shorts`
  String get s_exchange_longshort_ratio {
    return Intl.message(
      'Exchange Longs/Shorts',
      name: 's_exchange_longshort_ratio',
      desc: '',
      args: [],
    );
  }

  /// `Sort by`
  String get s_sortby {
    return Intl.message(
      'Sort by',
      name: 's_sortby',
      desc: '',
      args: [],
    );
  }

  /// `Markets`
  String get s_crypto_coin {
    return Intl.message(
      'Markets',
      name: 's_crypto_coin',
      desc: '',
      args: [],
    );
  }

  /// `Create Alert`
  String get s_add_alert {
    return Intl.message(
      'Create Alert',
      name: 's_add_alert',
      desc: '',
      args: [],
    );
  }

  /// `Futures`
  String get s_futures_market {
    return Intl.message(
      'Futures',
      name: 's_futures_market',
      desc: '',
      args: [],
    );
  }

  /// `Open Interest`
  String get s_header_oi {
    return Intl.message(
      'Open Interest',
      name: 's_header_oi',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get s_cancel {
    return Intl.message(
      'Cancel',
      name: 's_cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get s_ok {
    return Intl.message(
      'OK',
      name: 's_ok',
      desc: '',
      args: [],
    );
  }

  /// `New version update`
  String get s_is_upgrade {
    return Intl.message(
      'New version update',
      name: 's_is_upgrade',
      desc: '',
      args: [],
    );
  }

  /// `Current is up to date`
  String get s_last_version {
    return Intl.message(
      'Current is up to date',
      name: 's_last_version',
      desc: '',
      args: [],
    );
  }

  /// `Text Size`
  String get s_text_size {
    return Intl.message(
      'Text Size',
      name: 's_text_size',
      desc: '',
      args: [],
    );
  }

  /// `Small`
  String get s_font_small {
    return Intl.message(
      'Small',
      name: 's_font_small',
      desc: '',
      args: [],
    );
  }

  /// `Middle`
  String get s_font_middle {
    return Intl.message(
      'Middle',
      name: 's_font_middle',
      desc: '',
      args: [],
    );
  }

  /// `Large`
  String get s_font_large {
    return Intl.message(
      'Large',
      name: 's_font_large',
      desc: '',
      args: [],
    );
  }

  /// `Background Alpha`
  String get s_bg_alpha {
    return Intl.message(
      'Background Alpha',
      name: 's_bg_alpha',
      desc: '',
      args: [],
    );
  }

  /// `Portfolio`
  String get s_portfolio {
    return Intl.message(
      'Portfolio',
      name: 's_portfolio',
      desc: '',
      args: [],
    );
  }

  /// `Tip`
  String get s_tip {
    return Intl.message(
      'Tip',
      name: 's_tip',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get s_deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 's_deleteAccount',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '验证码已发送，请勿再点击' key

  // skipped getter for the 'Coinsoto使用条款' key

  // skipped getter for the '隐私政策' key

  // skipped getter for the '我同意' key

  // skipped getter for the '和' key

  /// `Other Setting`
  String get s_other_setting {
    return Intl.message(
      'Other Setting',
      name: 's_other_setting',
      desc: '',
      args: [],
    );
  }

  /// `Change main chart height`
  String get s_adjust_kchart_height {
    return Intl.message(
      'Change main chart height',
      name: 's_adjust_kchart_height',
      desc: '',
      args: [],
    );
  }

  /// `Up Candle`
  String get s_up_candle {
    return Intl.message(
      'Up Candle',
      name: 's_up_candle',
      desc: '',
      args: [],
    );
  }

  /// `I agree to`
  String get s_agreeto {
    return Intl.message(
      'I agree to',
      name: 's_agreeto',
      desc: '',
      args: [],
    );
  }

  /// `Solid`
  String get s_solid {
    return Intl.message(
      'Solid',
      name: 's_solid',
      desc: '',
      args: [],
    );
  }

  /// `Hollow`
  String get s_hollow {
    return Intl.message(
      'Hollow',
      name: 's_hollow',
      desc: '',
      args: [],
    );
  }

  /// `and`
  String get s_and {
    return Intl.message(
      'and',
      name: 's_and',
      desc: '',
      args: [],
    );
  }

  /// `Symbol Liquidations`
  String get s_symbol_liq {
    return Intl.message(
      'Symbol Liquidations',
      name: 's_symbol_liq',
      desc: '',
      args: [],
    );
  }

  /// `Coin Liquidations`
  String get s_coin_liquidation {
    return Intl.message(
      'Coin Liquidations',
      name: 's_coin_liquidation',
      desc: '',
      args: [],
    );
  }

  /// `Funding Rate K`
  String get s_fr_kline {
    return Intl.message(
      'Funding Rate K',
      name: 's_fr_kline',
      desc: '',
      args: [],
    );
  }

  /// `Open Interest K`
  String get s_oi_kline {
    return Intl.message(
      'Open Interest K',
      name: 's_oi_kline',
      desc: '',
      args: [],
    );
  }

  /// `Longs Shorts Person Ratio`
  String get s_longshort_person {
    return Intl.message(
      'Longs Shorts Person Ratio',
      name: 's_longshort_person',
      desc: '',
      args: [],
    );
  }

  /// `Top Trader Long/Short Ratio (Accounts)`
  String get s_top_trader_accounts_ratio {
    return Intl.message(
      'Top Trader Long/Short Ratio (Accounts)',
      name: 's_top_trader_accounts_ratio',
      desc: '',
      args: [],
    );
  }

  /// `Top Trader Long/Short Ratio (Positions)`
  String get s_top_trader_position_ratio {
    return Intl.message(
      'Top Trader Long/Short Ratio (Positions)',
      name: 's_top_trader_position_ratio',
      desc: '',
      args: [],
    );
  }

  /// `Please Open System Notification`
  String get s_notification_setting {
    return Intl.message(
      'Please Open System Notification',
      name: 's_notification_setting',
      desc: '',
      args: [],
    );
  }

  /// `Ma Line Width`
  String get s_ma_line_width {
    return Intl.message(
      'Ma Line Width',
      name: 's_ma_line_width',
      desc: '',
      args: [],
    );
  }

  /// `Multiple Charts`
  String get s_multiple_charts {
    return Intl.message(
      'Multiple Charts',
      name: 's_multiple_charts',
      desc: '',
      args: [],
    );
  }

  /// `Change Theme`
  String get s_change_theme {
    return Intl.message(
      'Change Theme',
      name: 's_change_theme',
      desc: '',
      args: [],
    );
  }

  /// `Remove User Data`
  String get s_del_userdata {
    return Intl.message(
      'Remove User Data',
      name: 's_del_userdata',
      desc: '',
      args: [],
    );
  }

  /// `Authorization hint`
  String get common_permission_hint {
    return Intl.message(
      'Authorization hint',
      name: 'common_permission_hint',
      desc: '',
      args: [],
    );
  }

  /// `You need to grant %s before using this function`
  String get common_permission_message {
    return Intl.message(
      'You need to grant %s before using this function',
      name: 'common_permission_message',
      desc: '',
      args: [],
    );
  }

  /// `granted`
  String get common_permission_granted {
    return Intl.message(
      'granted',
      name: 'common_permission_granted',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get common_permission_denied {
    return Intl.message(
      'Cancel',
      name: 'common_permission_denied',
      desc: '',
      args: [],
    );
  }

  /// `Authorization reminder`
  String get common_permission_alert {
    return Intl.message(
      'Authorization reminder',
      name: 'common_permission_alert',
      desc: '',
      args: [],
    );
  }

  /// `Authorization failed, please grant permission correctly`
  String get common_permission_fail_hint {
    return Intl.message(
      'Authorization failed, please grant permission correctly',
      name: 'common_permission_fail_hint',
      desc: '',
      args: [],
    );
  }

  /// `Authorization failed, please grant %s correctly`
  String get common_permission_fail_assign_hint {
    return Intl.message(
      'Authorization failed, please grant %s correctly',
      name: 'common_permission_fail_assign_hint',
      desc: '',
      args: [],
    );
  }

  /// `Failed to obtain permission, please grant permission manually`
  String get common_permission_manual_fail_hint {
    return Intl.message(
      'Failed to obtain permission, please grant permission manually',
      name: 'common_permission_manual_fail_hint',
      desc: '',
      args: [],
    );
  }

  /// `Failed to obtain permission, please manually grant %s`
  String get common_permission_manual_assign_fail_hint {
    return Intl.message(
      'Failed to obtain permission, please manually grant %s',
      name: 'common_permission_manual_assign_fail_hint',
      desc: '',
      args: [],
    );
  }

  /// `Failed to obtain background location permission,\nPlease select "Always Allow"`
  String get common_permission_background_location_fail_hint {
    return Intl.message(
      'Failed to obtain background location permission,\nPlease select "Always Allow"',
      name: 'common_permission_background_location_fail_hint',
      desc: '',
      args: [],
    );
  }

  /// `Failed to obtain background sensor permissions,\nPlease choose "Always Allow"`
  String get common_permission_background_sensors_fail_hint {
    return Intl.message(
      'Failed to obtain background sensor permissions,\nPlease choose "Always Allow"',
      name: 'common_permission_background_sensors_fail_hint',
      desc: '',
      args: [],
    );
  }

  /// `Failed to obtain media location permission\nPlease clear application data and try again`
  String get common_permission_media_location_hint_fail {
    return Intl.message(
      'Failed to obtain media location permission\nPlease clear application data and try again',
      name: 'common_permission_media_location_hint_fail',
      desc: '',
      args: [],
    );
  }

  /// `Go to authorization`
  String get common_permission_goto_setting_page {
    return Intl.message(
      'Go to authorization',
      name: 'common_permission_goto_setting_page',
      desc: '',
      args: [],
    );
  }

  /// `calendar permissions`
  String get common_permission_calendar {
    return Intl.message(
      'calendar permissions',
      name: 'common_permission_calendar',
      desc: '',
      args: [],
    );
  }

  /// `Camera permission`
  String get common_permission_camera {
    return Intl.message(
      'Camera permission',
      name: 'common_permission_camera',
      desc: '',
      args: [],
    );
  }

  /// `Contacts permissions`
  String get common_permission_contacts {
    return Intl.message(
      'Contacts permissions',
      name: 'common_permission_contacts',
      desc: '',
      args: [],
    );
  }

  /// `location permission`
  String get common_permission_location {
    return Intl.message(
      'location permission',
      name: 'common_permission_location',
      desc: '',
      args: [],
    );
  }

  /// `Background location permission`
  String get common_permission_location_background {
    return Intl.message(
      'Background location permission',
      name: 'common_permission_location_background',
      desc: '',
      args: [],
    );
  }

  /// `nearby device permissions`
  String get common_permission_wireless_devices {
    return Intl.message(
      'nearby device permissions',
      name: 'common_permission_wireless_devices',
      desc: '',
      args: [],
    );
  }

  /// `microphone permission`
  String get common_permission_microphone {
    return Intl.message(
      'microphone permission',
      name: 'common_permission_microphone',
      desc: '',
      args: [],
    );
  }

  /// `Phone permission`
  String get common_permission_phone {
    return Intl.message(
      'Phone permission',
      name: 'common_permission_phone',
      desc: '',
      args: [],
    );
  }

  /// `Call log permission`
  String get common_permission_call_log {
    return Intl.message(
      'Call log permission',
      name: 'common_permission_call_log',
      desc: '',
      args: [],
    );
  }

  /// `body sensor permissions`
  String get common_permission_sensors {
    return Intl.message(
      'body sensor permissions',
      name: 'common_permission_sensors',
      desc: '',
      args: [],
    );
  }

  /// `background body sensor permissions`
  String get common_permission_sensors_background {
    return Intl.message(
      'background body sensor permissions',
      name: 'common_permission_sensors_background',
      desc: '',
      args: [],
    );
  }

  /// `Fitness exercise permission`
  String get common_permission_activity_recognition_29 {
    return Intl.message(
      'Fitness exercise permission',
      name: 'common_permission_activity_recognition_29',
      desc: '',
      args: [],
    );
  }

  /// `Physical Activity Permission`
  String get common_permission_activity_recognition_30 {
    return Intl.message(
      'Physical Activity Permission',
      name: 'common_permission_activity_recognition_30',
      desc: '',
      args: [],
    );
  }

  /// `Read media file location permission`
  String get common_permission_media_location {
    return Intl.message(
      'Read media file location permission',
      name: 'common_permission_media_location',
      desc: '',
      args: [],
    );
  }

  /// `SMS permission`
  String get common_permission_sms {
    return Intl.message(
      'SMS permission',
      name: 'common_permission_sms',
      desc: '',
      args: [],
    );
  }

  /// `storage permission`
  String get common_permission_storage {
    return Intl.message(
      'storage permission',
      name: 'common_permission_storage',
      desc: '',
      args: [],
    );
  }

  /// `Permission to send notifications`
  String get common_permission_post_notifications {
    return Intl.message(
      'Permission to send notifications',
      name: 'common_permission_post_notifications',
      desc: '',
      args: [],
    );
  }

  /// `photo and video permissions`
  String get common_permission_image_and_video {
    return Intl.message(
      'photo and video permissions',
      name: 'common_permission_image_and_video',
      desc: '',
      args: [],
    );
  }

  /// `Music and audio permissions`
  String get common_permission_audio {
    return Intl.message(
      'Music and audio permissions',
      name: 'common_permission_audio',
      desc: '',
      args: [],
    );
  }

  /// `All file access permissions`
  String get common_permission_manage_storage {
    return Intl.message(
      'All file access permissions',
      name: 'common_permission_manage_storage',
      desc: '',
      args: [],
    );
  }

  /// `install application permission`
  String get common_permission_install {
    return Intl.message(
      'install application permission',
      name: 'common_permission_install',
      desc: '',
      args: [],
    );
  }

  /// `Floating window permission`
  String get common_permission_window {
    return Intl.message(
      'Floating window permission',
      name: 'common_permission_window',
      desc: '',
      args: [],
    );
  }

  /// `Modify system settings permissions`
  String get common_permission_setting {
    return Intl.message(
      'Modify system settings permissions',
      name: 'common_permission_setting',
      desc: '',
      args: [],
    );
  }

  /// `Notification permission`
  String get common_permission_notification {
    return Intl.message(
      'Notification permission',
      name: 'common_permission_notification',
      desc: '',
      args: [],
    );
  }

  /// `notification bar listening permission`
  String get common_permission_notification_listener {
    return Intl.message(
      'notification bar listening permission',
      name: 'common_permission_notification_listener',
      desc: '',
      args: [],
    );
  }

  /// `View usage permissions`
  String get common_permission_task {
    return Intl.message(
      'View usage permissions',
      name: 'common_permission_task',
      desc: '',
      args: [],
    );
  }

  /// `View alarm clock reminder permission`
  String get common_permission_alarm {
    return Intl.message(
      'View alarm clock reminder permission',
      name: 'common_permission_alarm',
      desc: '',
      args: [],
    );
  }

  /// `Do Not Disturb Permission`
  String get common_permission_not_disturb {
    return Intl.message(
      'Do Not Disturb Permission',
      name: 'common_permission_not_disturb',
      desc: '',
      args: [],
    );
  }

  /// `Ignore battery optimization permission`
  String get common_permission_ignore_battery {
    return Intl.message(
      'Ignore battery optimization permission',
      name: 'common_permission_ignore_battery',
      desc: '',
      args: [],
    );
  }

  /// `Picture in picture permission`
  String get common_permission_picture_in_picture {
    return Intl.message(
      'Picture in picture permission',
      name: 'common_permission_picture_in_picture',
      desc: '',
      args: [],
    );
  }

  /// `\tVPN\t permission`
  String get common_permission_vpn {
    return Intl.message(
      '\tVPN\t permission',
      name: 'common_permission_vpn',
      desc: '',
      args: [],
    );
  }

  /// `Aggregated OpenInterest`
  String get s_coin_oi_kline {
    return Intl.message(
      'Aggregated OpenInterest',
      name: 's_coin_oi_kline',
      desc: '',
      args: [],
    );
  }

  /// `Notification settings`
  String get s_notify_setting {
    return Intl.message(
      'Notification settings',
      name: 's_notify_setting',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get s_notify {
    return Intl.message(
      'Notification',
      name: 's_notify',
      desc: '',
      args: [],
    );
  }

  /// `Vip Strategy Signal`
  String get s_vip_signal {
    return Intl.message(
      'Vip Strategy Signal',
      name: 's_vip_signal',
      desc: '',
      args: [],
    );
  }

  /// `Abnormal Price Changes`
  String get s_abnormal_price_chg {
    return Intl.message(
      'Abnormal Price Changes',
      name: 's_abnormal_price_chg',
      desc: '',
      args: [],
    );
  }

  /// `Abnormal OI Changes`
  String get s_abnormal_oi_chg {
    return Intl.message(
      'Abnormal OI Changes',
      name: 's_abnormal_oi_chg',
      desc: '',
      args: [],
    );
  }

  /// `BTC Market Cap`
  String get s_marketcap_ratio {
    return Intl.message(
      'BTC Market Cap',
      name: 's_marketcap_ratio',
      desc: '',
      args: [],
    );
  }

  /// `Okx LongShort Person Ratio`
  String get s_ok_longshort_person_ratio {
    return Intl.message(
      'Okx LongShort Person Ratio',
      name: 's_ok_longshort_person_ratio',
      desc: '',
      args: [],
    );
  }

  /// `Binance LongShort Person Ratio`
  String get s_bn_longshort_person_ratio {
    return Intl.message(
      'Binance LongShort Person Ratio',
      name: 's_bn_longshort_person_ratio',
      desc: '',
      args: [],
    );
  }

  /// `Taker Buy/Sell Ratio`
  String get s_buysel_longshort_ratio {
    return Intl.message(
      'Taker Buy/Sell Ratio',
      name: 's_buysel_longshort_ratio',
      desc: '',
      args: [],
    );
  }

  /// `Ratio Chg`
  String get s_ratio_chg {
    return Intl.message(
      'Ratio Chg',
      name: 's_ratio_chg',
      desc: '',
      args: [],
    );
  }

  /// `Chg`
  String get s_home_chg {
    return Intl.message(
      'Chg',
      name: 's_home_chg',
      desc: '',
      args: [],
    );
  }

  /// `Total Futures OI`
  String get s_total_oi {
    return Intl.message(
      'Total Futures OI',
      name: 's_total_oi',
      desc: '',
      args: [],
    );
  }

  /// `24H Futures Volume`
  String get s_futures_vol_24h {
    return Intl.message(
      '24H Futures Volume',
      name: 's_futures_vol_24h',
      desc: '',
      args: [],
    );
  }

  /// `Alerts`
  String get s_home_alerts {
    return Intl.message(
      'Alerts',
      name: 's_home_alerts',
      desc: '',
      args: [],
    );
  }

  /// `OI Chg`
  String get s_oi_chg_short {
    return Intl.message(
      'OI Chg',
      name: 's_oi_chg_short',
      desc: '',
      args: [],
    );
  }

  /// `Price Chg`
  String get s_price_chg_short {
    return Intl.message(
      'Price Chg',
      name: 's_price_chg_short',
      desc: '',
      args: [],
    );
  }

  /// `24H Chg`
  String get s_24h_chg {
    return Intl.message(
      '24H Chg',
      name: 's_24h_chg',
      desc: '',
      args: [],
    );
  }

  /// `Exchange OI`
  String get s_exchange_oi {
    return Intl.message(
      'Exchange OI',
      name: 's_exchange_oi',
      desc: '',
      args: [],
    );
  }

  /// `Taker Buy/Sell Ratio Chart`
  String get s_takerbuy_longshort_ratio_chart {
    return Intl.message(
      'Taker Buy/Sell Ratio Chart',
      name: 's_takerbuy_longshort_ratio_chart',
      desc: '',
      args: [],
    );
  }

  /// `Current`
  String get s_current {
    return Intl.message(
      'Current',
      name: 's_current',
      desc: '',
      args: [],
    );
  }

  /// `1 Day`
  String get s_day {
    return Intl.message(
      '1 Day',
      name: 's_day',
      desc: '',
      args: [],
    );
  }

  /// `7 Day`
  String get s_week {
    return Intl.message(
      '7 Day',
      name: 's_week',
      desc: '',
      args: [],
    );
  }

  /// `30 Day`
  String get s_month {
    return Intl.message(
      '30 Day',
      name: 's_month',
      desc: '',
      args: [],
    );
  }

  /// `1 Year`
  String get s_year {
    return Intl.message(
      '1 Year',
      name: 's_year',
      desc: '',
      args: [],
    );
  }

  /// `Hide`
  String get s_hide {
    return Intl.message(
      'Hide',
      name: 's_hide',
      desc: '',
      args: [],
    );
  }

  /// `Predicted`
  String get s_show_pre_fr {
    return Intl.message(
      'Predicted',
      name: 's_show_pre_fr',
      desc: '',
      args: [],
    );
  }

  /// `USDT`
  String get s_u_fr {
    return Intl.message(
      'USDT',
      name: 's_u_fr',
      desc: '',
      args: [],
    );
  }

  /// `Coin`
  String get s_coin_fr {
    return Intl.message(
      'Coin',
      name: 's_coin_fr',
      desc: '',
      args: [],
    );
  }

  /// `BTC Investment Return Rate`
  String get s_btc_profit {
    return Intl.message(
      'BTC Investment Return Rate',
      name: 's_btc_profit',
      desc: '',
      args: [],
    );
  }

  /// `Grayscale`
  String get s_grayscale_data {
    return Intl.message(
      'Grayscale',
      name: 's_grayscale_data',
      desc: '',
      args: [],
    );
  }

  /// `Current Month Return Rate`
  String get s_current_month_return_rate {
    return Intl.message(
      'Current Month Return Rate',
      name: 's_current_month_return_rate',
      desc: '',
      args: [],
    );
  }

  /// `Grayscale Detail`
  String get s_grayscale_detail {
    return Intl.message(
      'Grayscale Detail',
      name: 's_grayscale_detail',
      desc: '',
      args: [],
    );
  }

  /// `OpenInterest Delta`
  String get s_oi_delta {
    return Intl.message(
      'OpenInterest Delta',
      name: 's_oi_delta',
      desc: '',
      args: [],
    );
  }

  /// `Funding Rates(OI Weighted)`
  String get s_oi_fr {
    return Intl.message(
      'Funding Rates(OI Weighted)',
      name: 's_oi_fr',
      desc: '',
      args: [],
    );
  }

  /// `Funding Rates(Volume Weighted)`
  String get s_vol_fr {
    return Intl.message(
      'Funding Rates(Volume Weighted)',
      name: 's_vol_fr',
      desc: '',
      args: [],
    );
  }

  /// `Longs Shorts Ratio(Accounts Candle)`
  String get s_ls_accounts_k {
    return Intl.message(
      'Longs Shorts Ratio(Accounts Candle)',
      name: 's_ls_accounts_k',
      desc: '',
      args: [],
    );
  }

  /// `Top Trader Longs Shorts Ratio(Accounts Candle)`
  String get s_ls_top_accounts_k {
    return Intl.message(
      'Top Trader Longs Shorts Ratio(Accounts Candle)',
      name: 's_ls_top_accounts_k',
      desc: '',
      args: [],
    );
  }

  /// `Top Trader Longs Shorts Ratio(Positions Candle)`
  String get s_ls_top_positions_ratio_k {
    return Intl.message(
      'Top Trader Longs Shorts Ratio(Positions Candle)',
      name: 's_ls_top_positions_ratio_k',
      desc: '',
      args: [],
    );
  }

  /// `Liquidation Map`
  String get s_liqmap {
    return Intl.message(
      'Liquidation Map',
      name: 's_liqmap',
      desc: '',
      args: [],
    );
  }

  /// `Liq Map Detail`
  String get s_liq_detail {
    return Intl.message(
      'Liq Map Detail',
      name: 's_liq_detail',
      desc: '',
      args: [],
    );
  }

  /// `OrderFlow`
  String get s_order_flow {
    return Intl.message(
      'OrderFlow',
      name: 's_order_flow',
      desc: '',
      args: [],
    );
  }

  /// `Copied`
  String get copied {
    return Intl.message(
      'Copied',
      name: 'copied',
      desc: '',
      args: [],
    );
  }

  /// `The server is busy, please try again later`
  String get theServerIsBusyPleaseTryAgainLater {
    return Intl.message(
      'The server is busy, please try again later',
      name: 'theServerIsBusyPleaseTryAgainLater',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'zh'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
