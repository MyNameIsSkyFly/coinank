import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class MessageHostApi {
  void changeDarkMode(bool isDark);

  void changeLanguage(String languageCode);

  void changeUpColor(bool isGreenUp);

  ///图表模块跳转
  ///json格式:{
  ///"success":true,
  ///"code":1,
  ///"data:UserInfo.toJson()
  ///}
  void saveLoginInfo(String userInfoWithBaseEntityJson);

  ///安卓悬浮窗设置
  void toAndroidFloatingWindow();

  ///安卓关闭状态下通过悬浮窗打开app后拿到跳转kline数据
  List<String?>? getToKlineParams();
}

@FlutterApi()
// ignore: one_member_abstracts
abstract class MessageFlutterApi {
  void toKLine(
      String exchangeName, String symbol, String baseCoin, String? productType);
}
