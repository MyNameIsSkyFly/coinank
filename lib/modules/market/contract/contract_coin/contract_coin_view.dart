import 'package:ank_app/modules/market/contract/contract_coin/widgets/customize_filter_header_view.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contract_coin_logic.dart';
import 'widgets/contract_coin_grid_view.dart';


class ContractCoinPage extends StatefulWidget {
  const ContractCoinPage({super.key});

  @override
  State<ContractCoinPage> createState() => _ContractCoinPageState();
}

class _ContractCoinPageState extends State<ContractCoinPage> {
  final logic = Get.put(ContractCoinLogic());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomizeFilterHeaderView(onFinishFilter: () => logic.onRefresh()),
        Expanded(
          child: EasyRefresh(
            footer: const MaterialFooter(),
            onRefresh: logic.onRefresh,
            child: ContractCoinGridView(logic: logic),
          ),
        ),
      ],
    );
  }
}
