import 'package:ank_app/modules/market/contract/contract_coin/widgets/customize_filter_header_view.dart';
import 'package:ank_app/modules/market/spot/widgets/spot_coin_data_grid_view.dart';
import 'package:ank_app/widget/app_refresh.dart';
import 'package:ank_app/widget/empty_view.dart';
import 'package:ank_app/widget/visibility_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'spot_coin_logic.dart';

class SpotCoinView extends StatefulWidget {
  const SpotCoinView({super.key});

  @override
  State<SpotCoinView> createState() => _SpotCoinViewState();
}

class _SpotCoinViewState extends VisibilityState<SpotCoinView> {
  final logic = Get.put(SpotCoinLogic(isCategory: false));

  @override
  Widget builder(BuildContext context) {
    return Column(
      children: [
        CustomizeFilterHeaderView(
          isSpot: true,
          onFinishFilter: () => logic.onRefresh(showLoading: true),
        ),
        Expanded(child: Obx(() {
          return Stack(
            children: [
              AppRefresh(
                  onRefresh: () async => logic.onRefresh(),
                  child: SpotCoinGridView(logic: logic)),
              if (logic.data.isEmpty && !logic.isInitializing.value)
                const Center(child: EmptyView(size: 150)),
            ],
          );
        })),
      ],
    );
  }

  @override
  void onVisibleAgain() {
    logic.stopTimer();
    logic.onRefresh().then((value) => logic.startTimer());
  }
}
