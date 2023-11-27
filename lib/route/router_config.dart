import 'package:ank_app/modules/home/exchange_oi/exchange_oi_view.dart';
import 'package:ank_app/modules/home/exchange_oi/exchange_oi_view.dart';
import 'package:ank_app/modules/login/login_view.dart';
import 'package:ank_app/modules/login/register_view.dart';
import 'package:ank_app/modules/main/main_binding.dart';
import 'package:ank_app/modules/main/main_view.dart';
import 'package:ank_app/modules/market/contract_market_search/contract_market_search_binding.dart';
import 'package:ank_app/modules/market/contract_market_search/contract_market_search_view.dart';
import 'package:ank_app/modules/market/contract_search/contract_search_binding.dart';
import 'package:ank_app/modules/market/contract_search/contract_search_view.dart';
import 'package:get/get.dart';

class RouteConfig {
  static const String main = '/';
  static const String contractSearch = '/marker/contract/search';
  static const String contractMarketSearch = '/marker/contractMarket/search';

  static final List<GetPage> getPages = [
    GetPage(name: main, page: () => MainPage(), binding: MainBinding()),
    GetPage(
        name: contractSearch,
        page: () => ContractSearchPage(),
        binding: ContractSearchBinding()),
    GetPage(
        name: contractMarketSearch,
        page: () => ContractMarketSearchPage(),
        binding: ContractMarketSearchBinding()),
    GetPage(
      name: LoginPage.routeName,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: RegisterPage.routeName,
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: ExchangeOiPage.routeName,
      page: () => const ExchangeOiPage(),
    ),
  ];
}
