import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class MessageHostApi {
  ///合约总持仓
  void toTotalOi();

  void changeDarkMode(bool isDark);

  void changeLanguage(String languageCode);

  void changeUpColor(bool isGreenUp);

  ///清算地图
  void toLiqMap();

  ///多空持仓比
  void toLongShortAccountRatio();

  ///主动买卖多空比
  void toTakerBuyLongShortRatio();

  ///持仓变化
  void toOiChange();

  ///价格变化
  void toPriceChange();

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
}

@FlutterApi()
abstract class MessageFlutterApi {

  void toKLine(String exchangeName, String symbol);
}
