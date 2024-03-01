import 'package:ank_app/constants/urls.dart';
import 'package:ank_app/modules/home/exchange_oi/exchange_oi_view.dart';
import 'package:ank_app/modules/market/funding_rate/funding_rate_view.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:ank_app/widget/keep_alive_page.dart';
import 'package:flutter/material.dart';

import 'contract_coin/contract_coin_view.dart';
import 'contract_coin/favorite_coin_view.dart';

class MarketState {
  TabController? tabController;
  late List<Widget> tabPage;
  String? exchangeOIBaseCoin;

  MarketState() {
    tabPage = [
      keepAlivePage(const FavoriteCoinPage()),
      keepAlivePage(const ContractCoinPage()),
      keepAlivePage(const ExchangeOiPage()),
      // keepAlivePage(const ContractMarketPage()),
      keepAlivePage(CommonWebView(url: Urls.urlLiquidation, showLoading: true)),
      keepAlivePage(const FundingRatePage()),
    ];
  }
}
