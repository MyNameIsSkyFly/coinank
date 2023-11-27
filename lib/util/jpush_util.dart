import 'dart:convert';
import 'dart:io';

import 'package:ank_app/res/export.dart';
import 'package:ank_app/route/app_nav.dart';
import 'package:ank_app/util/store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class JPushUtil {
  JPushUtil._();

  factory JPushUtil() => _instance;
  static final _instance = JPushUtil._();
  final JPush _jpush = JPush();

  Future<void> initPlatformState() async {
    String? platformVersion;

    try {
      _jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print('flutter onReceiveNotification: $message');
        _handeData(message);
      }, onOpenNotification: (Map<String, dynamic> message) async {
        print('flutter onOpenNotification: $message');
        _jpush.setBadge(0);
        _handeData(message);
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print('flutter onReceiveMessage: $message');
        _handeData(message);
      }, onReceiveNotificationAuthorization:
              (Map<String, dynamic> message) async {
        print('flutter onReceiveNotificationAuthorization: $message');
      }, onNotifyMessageUnShow: (Map<String, dynamic> message) async {
        print('flutter onNotifyMessageUnShow: $message');
      }, onInAppMessageShow: (Map<String, dynamic> message) async {
        print('flutter onInAppMessageShow: $message');
      }, onInAppMessageClick: (Map<String, dynamic> message) async {
        print('flutter onInAppMessageClick: $message');
      }, onConnected: (Map<String, dynamic> message) async {
        print('flutter onConnected: $message');
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    _jpush.setAuth(enable: true);
    _jpush.setup(
      appKey: '8de9d5e306e08c49a078ab5f',
      channel: 'developer-default',
      production: !kDebugMode,
      debug: kDebugMode,
    );
    _jpush.applyPushAuthority(
        const NotificationSettingsIOS(sound: true, alert: true, badge: true));

    _jpush.getRegistrationID().then((rid) async {
      print('getRegistrationID:$rid');
      if (rid.isNotEmpty) {
        await StoreLogic.to.saveDeviceId(rid);
        await AppUtil.updateAppInfo();
      }
    });
  }

  _handeData(Map<String, dynamic> message) {
    if (Platform.isAndroid) {
      final extra = message['extras']['cn.jpush.android.EXTRA'] as String;
      final map = jsonDecode(extra) as Map<String, dynamic>;
      if (map.containsKey('url')) {
        AppNav.openWebUrl(url: map['url'] as String, title: 'Coinank');
      }
    } else {
      final extra = message['extras'] as String;
      final map = jsonDecode(extra) as Map<String, dynamic>;
      if (map.containsKey('url')) {
        AppNav.openWebUrl(url: map['url'] as String, title: 'Coinank');
      }
    }
  }
}
