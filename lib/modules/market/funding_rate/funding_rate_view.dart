import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'funding_rate_logic.dart';

class FundingRatePage extends StatelessWidget {
  FundingRatePage({Key? key}) : super(key: key);

  final logic = Get.put(FundingRateLogic());
  final state = Get.find<FundingRateLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
