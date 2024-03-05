import 'dart:async';

import 'package:ank_app/entity/event/theme_event.dart';
import 'package:ank_app/modules/market/spot/spot_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

part '_data_grid_view.dart';

class SpotPage extends StatefulWidget {
  const SpotPage({super.key});

  @override
  State<SpotPage> createState() => _SpotPageState();
}

class _SpotPageState extends State<SpotPage> {
  final logic = Get.put(SpotLogic());

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
        onRefresh: () async => logic.getMarketData(),
        child: _DataGridView(logic: logic));
  }
}
