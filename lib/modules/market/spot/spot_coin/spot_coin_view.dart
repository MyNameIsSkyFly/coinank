import 'package:ank_app/generated/assets.dart';
import 'package:ank_app/modules/market/contract/contract_coin/widgets/customize_filter_header_view.dart';
import 'package:ank_app/modules/market/spot/widgets/spot_coin_data_grid_view.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'spot_coin_logic.dart';

class SpotCoinView extends StatelessWidget {
  SpotCoinView({super.key});

  final logic = Get.put(SpotCoinLogic(isCategory: false));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomizeFilterHeaderView(
          isSpot: true,
          onFinishFilter: () => logic.onRefresh(showLoading: true),
        ),
        Expanded(child: Obx(() {
          return Stack(
            children: [
              EasyRefresh(
                  onRefresh: () async => logic.onRefresh(),
                  child: SpotCoinGridView(logic: logic)),
              if (logic.data.isEmpty && !logic.isInitializing.value)
                Center(
                    child: Image.asset(Assets.commonIcEmptyBox,
                        height: 150, width: 150)),
            ],
          );
        })),
      ],
    );
  }
}
