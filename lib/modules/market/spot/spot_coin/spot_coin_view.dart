import 'package:ank_app/modules/market/spot/widgets/spot_coin_data_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'spot_coin_logic.dart';

class SpotCoinView extends StatelessWidget {
  SpotCoinView({super.key});

  final logic = Get.put(SpotCoinLogic());

  @override
  Widget build(BuildContext context) {
    return SpotCoinGridView(logic: logic);
  }
}
