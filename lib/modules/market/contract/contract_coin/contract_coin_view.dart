import 'dart:async';

import 'package:ank_app/entity/event/theme_event.dart';
import 'package:ank_app/res/export.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'contract_coin_logic.dart';

part '_data_grid_view.dart';

class ContractCoinPage extends StatelessWidget {
  const ContractCoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(ContractCoinLogic());
    final state = Get.find<ContractCoinLogic>().state;
    return Obx(() {
      return state.isLoading.value
          ? const LottieIndicator(
              margin: EdgeInsets.only(top: 200),
            )
          : EasyRefresh(
              onRefresh: logic.onRefresh,
              child: _DataGridView(logic: logic),
            );
    });
  }
}
