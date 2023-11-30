import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class MessageHostApi {
  void changeDarkMode(bool isDark);

  void changeLanguage(String languageCode);

  void changeUpColor(bool isGreenUp);

  ///图表模块跳转
  void toChartWeb(String url, String title);

  ///图表模块跳转
  ///json格式:{
  ///"success":true,
  ///"code":1,
  ///"data:UserInfo.toJson()
  ///}
  void saveLoginInfo(String userInfoWithBaseEntityJson);

  ///安卓悬浮窗设置
  void toAndroidFloatingWindow();
}

@FlutterApi()
abstract class MessageFlutterApi {
  void toKLine(
      String exchangeName, String symbol, String baseCoin, String? productType);
}
