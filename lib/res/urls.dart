import 'package:ank_app/util/app_util.dart';

class Urls {
  static String strDomain = 'coinsoto.com';
  static String h5Prefix = 'https://$strDomain';
  static String get webLanguage => AppUtil.getWebLanguage();

  static String get urlProChart => '$h5Prefix/${webLanguage}proChart';
}
