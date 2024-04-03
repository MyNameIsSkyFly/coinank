import 'package:ank_app/modules/home/exchange_oi/exchange_oi_view.dart';
import 'package:ank_app/modules/market/contract/contract_liq/contract_liq_view.dart';
import 'package:ank_app/modules/market/contract/funding_rate/funding_rate_view.dart';
import 'package:ank_app/widget/keep_alive_page.dart';
import 'package:flutter/material.dart';

import '../market_category/category_view.dart';
import 'contract_coin/contract_coin_view.dart';
import 'contract_coin/favorite/contract_coin_view_f.dart';

class ContractState {
  TabController? tabController;
  late List<Widget> tabPage;
  String? exchangeOIBaseCoin;

  ContractState() {
    tabPage = [
      keepAlivePage(const ContractCoinPageF()),
      keepAlivePage(const ContractCoinPage()),
      keepAlivePage(const ContractCategoryPage()),
      keepAlivePage(const ExchangeOiPage()),
      // keepAlivePage(const ContractLiqPage()),
      const ContractLiqPage(),
      keepAlivePage(const FundingRatePage()),
    ];
  }
}
