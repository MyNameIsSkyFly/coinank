import 'package:ank_app/modules/alert/alert_manage_view.dart';
import 'package:ank_app/modules/coin_detail/coin_detail_view.dart';
import 'package:ank_app/modules/home/liq_main/liq_main_binding.dart';
import 'package:ank_app/modules/home/liq_main/liq_main_view.dart';
import 'package:ank_app/modules/home/long_short_ratio/long_short_person_ratio/long_short_person_ratio_view.dart';
import 'package:ank_app/modules/home/long_short_ratio/long_short_ratio_binding.dart';
import 'package:ank_app/modules/home/long_short_ratio/long_short_ratio_view.dart';
import 'package:ank_app/modules/home/price_change/price_change_binding.dart';
import 'package:ank_app/modules/home/price_change/price_change_view.dart';
import 'package:ank_app/modules/login/login_view.dart';
import 'package:ank_app/modules/login/register_view.dart';
import 'package:ank_app/modules/main/main_binding.dart';
import 'package:ank_app/modules/main/main_view.dart';
import 'package:ank_app/modules/market/contract/contract_coin/customize/edit_customize_view.dart';
import 'package:ank_app/modules/market/contract/contract_coin/customize/reorder_view.dart';
import 'package:ank_app/modules/market/contract/contract_market_search/contract_market_search_binding.dart';
import 'package:ank_app/modules/market/contract/contract_market_search/contract_market_search_view.dart';
import 'package:ank_app/modules/market/market_category/category_detail/category_detail_view.dart';
import 'package:ank_app/modules/market/spot/customize/edit_customize_spot_view.dart';
import 'package:ank_app/modules/market/spot/customize/reorder_spot_view.dart';
import 'package:ank_app/modules/news/news_detail/news_detail_view.dart';
import 'package:ank_app/modules/setting/about/about_view.dart';
import 'package:ank_app/modules/setting/contact_us/contact_us_view.dart';
import 'package:get/get.dart';

import '../modules/alert/record/alert_record_view.dart';
import '../modules/home/home_search/home_search_view.dart';

class RouteConfig {
  static const String main = '/';
  static const String contractMarketSearch = '/marker/contractMarket/search';

  static final List<GetPage> getPages = [
    GetPage(name: main, page: () => const MainPage(), binding: MainBinding()),
    GetPage(
        name: contractMarketSearch,
        page: ContractMarketSearchPage.new,
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
        name: PriceChangePage.priceChange,
        page: PriceChangePage.new,
        binding: PriceChangeBinding()),
    GetPage(
        name: LongShortRatioPage.routeName,
        page: LongShortRatioPage.new,
        binding: LongShortRatioBinding()),
    GetPage(
        name: LiqMainPage.routeName,
        page: LiqMainPage.new,
        binding: LiqMainBinding()),
    GetPage(
      name: LongShortPersonRatioPage.routeName,
      page: () => const LongShortPersonRatioPage(),
    ),
    GetPage(
      name: HomeSearchPage.routeName,
      page: HomeSearchPage.new,
    ),
    GetPage(
      name: ContactUsPage.routeName,
      page: ContactUsPage.new,
    ),
    GetPage(
      name: AboutPage.routeName,
      page: AboutPage.new,
    ),
    GetPage(
      name: CoinDetailPage.routeName,
      page: () => const CoinDetailPage(),
    ),
    GetPage(
      name: ReorderPage.routeName,
      page: ReorderPage.new,
    ),
    GetPage(
      name: EditCustomizePage.routeName,
      page: () => const EditCustomizePage(),
    ),
    GetPage(
      name: ReorderSpotPage.routeName,
      page: ReorderSpotPage.new,
    ),
    GetPage(
      name: EditCustomizeSpotPage.routeName,
      page: () => const EditCustomizeSpotPage(),
    ),
    GetPage(
      name: CategoryDetailPage.routeName,
      page: () => const CategoryDetailPage(),
    ),
    GetPage(
      name: NewsDetailPage.routeName,
      page: () => const NewsDetailPage(),
    ),
    GetPage(
      name: AlertRecordPage.routeName,
      page: AlertRecordPage.new,
    ),
    GetPage(
      name: AlertManagePage.routeName,
      page: AlertManagePage.new,
    ),
  ];
}
