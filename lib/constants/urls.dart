import 'package:ank_app/util/app_util.dart';

class Urls {
  static String strDomain = 'tv.coinsoto.com';
  static String h5Prefix = 'https://$strDomain';
  static String depthOrderDomain = 'cdn01.coinsoto.com';
  static String uniappDomain =
      'https://coinsoto-h5.s3.ap-northeast-1.amazonaws.com';

  static String get webLanguage => AppUtil.webLanguage;

  static String get urlProChart => '$h5Prefix/${webLanguage}proChart';

  static String get urlPrivacy => '$h5Prefix/${webLanguage}privacy';

  static String get urlDisclaimer => '$h5Prefix/${webLanguage}disclaimer';

  static String get urlAbout => '$h5Prefix/${webLanguage}about';

  //爆仓数据
  static String get urlLiquidation =>
      '$uniappDomain/index.html#/pages/liquidation/index';

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
