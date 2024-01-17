import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/modules/home/exchange_oi/exchange_oi_view.dart';
import 'package:ank_app/modules/market/contract/contract_view.dart';
import 'package:ank_app/modules/market/contract/favorite_view.dart';
import 'package:ank_app/modules/market/contract_market/contract_market_view.dart';
import 'package:ank_app/modules/market/funding_rate/funding_rate_view.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:ank_app/widget/keep_alive_page.dart';
import 'package:flutter/material.dart';

class MarketState {
  TabController? tabController;
  late List<Widget> tabPage;
  String? exchangeOIBaseCoin;

  MarketState() {
    tabPage = [
      keepAlivePage(const FavoritePage()),
      keepAlivePage(const ContractPage()),
      keepAlivePage(const ExchangeOiPage()),
      keepAlivePage(const ContractMarketPage()),
      keepAlivePage(CommonWebView(url: Urls.urlLiquidation, showLoading: true)),
      keepAlivePage(const FundingRatePage()),
    ];
  }
}
