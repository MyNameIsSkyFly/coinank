import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'liquidation_data_logic.dart';

class LiquidationDataPage extends StatelessWidget {
  LiquidationDataPage({Key? key}) : super(key: key);

  final logic = Get.put(LiquidationDataLogic());
  final state = Get.find<LiquidationDataLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
