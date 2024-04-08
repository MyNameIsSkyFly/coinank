import 'package:ank_app/res/export.dart';

class Urls {
  static String get strDomain => StoreLogic.to.domain;

  static String get h5Prefix => StoreLogic.to.h5Prefix;

  static String get apiPrefix => StoreLogic.to.apiPrefix;

  static String get chartUrl => StoreLogic.to.chartUrl;

  static String get heatMapUrl => StoreLogic.to.heatMapUrl;

  static String get categoryHeatMapUrl => StoreLogic.to.categoryHeatMapUrl;

  static String get categoryChartUrl => StoreLogic.to.categoryChartUrl;

  static String get liqHeatMapUrl => StoreLogic.to.liqHeatMapUrl;

  static String get klineUrl => StoreLogic.to.klineUrl;

  static String get depthOrderDomain => StoreLogic.to.depthOrderDomain;

  static String get uniappDomain => StoreLogic.to.uniappDomain;

  static String get websocketUrl => StoreLogic.to.websocketUrl;

  static String get webLanguage => AppUtil.webLanguage;

  static String get urlProChart => '$h5Prefix/${webLanguage}proChart';

  static String get urlPrivacy => '$h5Prefix/${webLanguage}privacy';

  static String get urlDisclaimer => '$h5Prefix/${webLanguage}disclaimer';

  static String get urlAbout => '$h5Prefix/${webLanguage}about';

  static String get urlBRC => '$h5Prefix/${webLanguage}ordinals/brc20';

  static String get urlBRCHeatMap =>
      '$h5Prefix/${webLanguage}ordinals/brc20/heatmap';

  //爆仓数据
  // static String get urlLiquidation =>
  //     '$uniappDomain/index.html#/pages/liquidation/index';

  //投资组合
  static String get urlPortfolio => '$h5Prefix/${webLanguage}users/portfolio';

  //首页提醒
  static String get urlNotification =>
      '$h5Prefix/${webLanguage}users/noticeConfig';

  //贪婪指数
  static String get urlGreedIndex =>
      '$h5Prefix/${webLanguage}indexdata/feargreedIndex';

  //贪婪指数
  static String get urlBTCMarketCap =>
      '$h5Prefix/${webLanguage}indexdata/btcMarketCap';

  //24H合约成交量
  static String get url24HOIVol =>
      '$h5Prefix/${webLanguage}indexdata/oivol/vol24h';

  //btc投资回报率
  static String get urlBTCProfit => '$h5Prefix/${webLanguage}indexdata/profit';

  //灰度数据
  static String get urlGrayscale => '$h5Prefix/${webLanguage}grayscale';
}
