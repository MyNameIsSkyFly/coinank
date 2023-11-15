import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contract_market_logic.dart';

class ContractMarketPage extends StatelessWidget {
  ContractMarketPage({Key? key}) : super(key: key);

  final logic = Get.put(ContractMarketLogic());
  final state = Get.find<ContractMarketLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
