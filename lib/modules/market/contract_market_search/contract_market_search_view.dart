import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contract_market_search_logic.dart';

class ContractMarketSearchPage extends StatelessWidget {
  ContractMarketSearchPage({Key? key}) : super(key: key);

  final logic = Get.find<ContractMarketSearchLogic>();
  final state = Get.find<ContractMarketSearchLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
