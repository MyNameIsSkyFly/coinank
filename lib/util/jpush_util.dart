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
        print("flutter onReceiveNotification: $message");
      }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
      }, onReceiveNotificationAuthorization:
              (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
      }, onNotifyMessageUnShow: (Map<String, dynamic> message) async {
        print("flutter onNotifyMessageUnShow: $message");
      }, onInAppMessageShow: (Map<String, dynamic> message) async {
        print("flutter onInAppMessageShow: $message");
      }, onInAppMessageClick: (Map<String, dynamic> message) async {
        print("flutter onInAppMessageClick: $message");
      }, onConnected: (Map<String, dynamic> message) async {
        print("flutter onConnected: $message");
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    _jpush.setAuth(enable: true);
    _jpush.setup(
      appKey: 'b475c5612b06aa19f6057a6a', //你自己应用的 AppKey
      channel: 'developer-default',
      production: !kDebugMode,
      debug: kDebugMode,
    );
    _jpush.applyPushAuthority(
        const NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.
    _jpush.getRegistrationID().then((rid) {
      print('getRegistrationID:$rid');
    });
    _jpush.setAlias('coinank_tester');
  }
}
