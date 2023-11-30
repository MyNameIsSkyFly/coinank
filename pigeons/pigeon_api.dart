import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class MessageHostApi {
  void changeDarkMode(bool isDark);

  void changeLanguage(String languageCode);

  void changeUpColor(bool isGreenUp);

  ///贪婪指数
  void toGreedIndex();

  ///BTC市值占比
  void toBtcMarketRatio();

  ///24H合约成交量
  void toFuturesVolume();

  ///BTC投资回报率
  void toBtcProfitRate();

  ///灰度数据
  void toGrayScaleData();

  ///资金费率
  void toFundRate();

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
