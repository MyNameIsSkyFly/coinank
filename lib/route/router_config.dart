import 'package:ank_app/modules/main/main_binding.dart';
import 'package:ank_app/modules/main/main_view.dart';
import 'package:get/get.dart';

class RouteConfig {
  static const String main = '/';
  static final List<GetPage> getPages = [
    GetPage(name: main, page: () => MainPage(), binding: MainBinding()),
  ];
}
