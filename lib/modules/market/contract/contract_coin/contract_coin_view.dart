import 'package:ank_app/modules/market/contract/contract_coin/widgets/customize_filter_header_view.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/app_refresh.dart';
import 'package:ank_app/widget/visibility_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contract_coin_logic.dart';
import 'widgets/contract_coin_grid_view.dart';


class ContractCoinPage extends StatefulWidget {
  const ContractCoinPage({super.key});

  @override
  State<ContractCoinPage> createState() => _ContractCoinPageState();
}

class _ContractCoinPageState extends VisibilityState<ContractCoinPage> {
  final logic = Get.put(ContractCoinLogic(isCategory: false));

  @override
  Widget builder(BuildContext context) {
    return Column(
      children: [
        CustomizeFilterHeaderView(
            onFinishFilter: () => logic.onRefresh(showLoading: true)),
        Expanded(
          child: Obx(() {
            return Stack(
              children: [
                AppRefresh(
                  onRefresh: () async => logic.onRefresh(),
                  child: ContractCoinGridView(logic: logic),
                ),
                if (logic.data.isEmpty && !logic.isInitializing.value)
                  Center(
                      child: Image.asset(Assets.commonIcEmptyBox,
                          height: 150, width: 150)),
              ],
            );
          }),
        ),
      ],
    );
  }

  @override
  void onVisibleAgain() {
    logic.stopTimer();
    logic.onRefresh().then((value) => logic.startTimer());
  }
}
