import 'package:ank_app/util/app_util.dart';

class Urls {
  static String strDomain = 'coinsoto.com';
  static String h5Prefix = 'https://$strDomain';
  static String depthOrderDomain = 'cdn01.coinsoto.com';
  static String uniappDomain = 'coinsoto-h5.s3.ap-northeast-1.amazonaws.com';

  static String get webLanguage => AppUtil.webLanguage;

  static String get urlProChart => '$h5Prefix/${webLanguage}proChart';

  static String get urlPrivacy => '$h5Prefix/${webLanguage}privacy';

  static String get urlDisclaimer => '$h5Prefix/${webLanguage}disclaimer';

  static String get urlAbout => '$h5Prefix/${webLanguage}about';
}
