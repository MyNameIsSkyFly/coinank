// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:ank_app/res/export.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jpush_google_flutter/jpush_google_flutter.dart';

class JPushUtil {
  JPushUtil._();

  factory JPushUtil() => _instance;
  static final _instance = JPushUtil._();
  final JPush _jpush = JPush();

  Future<void> initPlatformState() async {
    try {
      _jpush.requestRequiredPermission();
      _jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print('flutter onReceiveNotification: $message');
      }, onOpenNotification: (Map<String, dynamic> message) async {
        print('flutter onOpenNotification: $message');
        _handeData(message);
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print('flutter onReceiveMessage: $message');
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
        _jpush.getRegistrationID().then((rid) async {
          print('getRegistrationID:$rid');
          if (rid.isNotEmpty) {
            await StoreLogic.to.saveDeviceId(rid);
            await AppUtil.updateAppInfo();
          }
        });
      });
    } on PlatformException {
      print('Failed to get platform version.');
    }

    _jpush.setAuth(enable: true);
    _jpush.setup(
      appKey: '8de9d5e306e08c49a078ab5f',
      channel: 'developer-default',
      production: !kDebugMode,
      debug: kDebugMode,
    );

    _jpush.getRegistrationID().then((rid) async {
      print('getRegistrationID:$rid');
      if (rid.isNotEmpty) {
        await StoreLogic.to.saveDeviceId(rid);
        await AppUtil.updateAppInfo();
      }
    });
    _jpush.applyPushAuthority(
        const NotificationSettingsIOS(sound: true, alert: true, badge: true));
  }

  _handeData(Map<String, dynamic> message) async {
    if (Platform.isAndroid) {
      _jpush.clearNotification(
          notificationId: message['extras']
              ['cn.jpush.android.NOTIFICATION_ID']);
      final extra = message['extras']['cn.jpush.android.EXTRA'] as String;
      final map = jsonDecode(extra) as Map<String, dynamic>;
      if (map.containsKey('url')) {
        AppNav.openWebUrl(
          url: map['url'] as String,
          title: 'Coinank',
          showLoading: true,
        );
      }
    } else {
      final map = message['extras'];
      if (map.containsKey('url')) {
        AppNav.openWebUrl(
          url: map['url'] as String,
          title: 'Coinank',
          showLoading: true,
        );
      }
    }
  }
}
