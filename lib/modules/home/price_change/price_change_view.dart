import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/market_datagrid_sizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'price_change_logic.dart';

part '_grid_view.dart';

class PriceChangePage extends StatelessWidget {
  PriceChangePage({super.key});

  static const String priceChange = '/home/priceChange';

  final logic = Get.find<PriceChangeLogic>();
  final state = Get.find<PriceChangeLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitleBar(
        title: state.isPrice ? S.current.s_price_chg : S.current.s_oi_chg,
      ),
      body: Obx(() {
        return state.isLoading.value
            ? const LottieIndicator()
            : EasyRefresh(
                onRefresh: () => logic.onRefresh(false),
                child: _GridView(),
              );
      }),
    );
  }
}
