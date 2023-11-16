import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class MessageHostApi {
  ///合约总持仓
  void toTotalOi();
}

@FlutterApi()
abstract class MessageFlutterApi {
  String flutterMethodExample(String? example);
}
