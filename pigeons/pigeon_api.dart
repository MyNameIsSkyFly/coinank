import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class MessageHostApi {
  ///合约总持仓
  void toTotalOi();

  void changeDarkMode(bool isDark);

  void changeLanguage(String languageCode);

  void changeUpColor(bool isGreenUp);
}

@FlutterApi()
abstract class MessageFlutterApi {
  String flutterMethodExample(String? example);
}
