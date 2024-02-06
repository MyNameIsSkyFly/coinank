import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_overview/widget/_tip_dialog.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'coin_detail_hold_logic.dart';
import 'widget/_data_grid_view.dart';
import 'widget/_hold_chart_view.dart';

class CoinDetailHoldView extends StatefulWidget {
  const CoinDetailHoldView({super.key});

  @override
  State<CoinDetailHoldView> createState() => _CoinDetailHoldViewState();
}

class _CoinDetailHoldViewState extends State<CoinDetailHoldView> {
  final logic = Get.put(CoinDetailHoldLogic());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15),
            child: Text(
              '大户持币占比趋势',
              style: Styles.tsBody_16m(context),
            ),
          ),
          HoldChartView(logic: logic),
          const Gap(10),
          Divider(height: 8, thickness: 8, color: Theme.of(context).cardColor),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: Row(
              children: [
                Text(
                  '十大流动地址',
                  style: Styles.tsBody_16m(context),
                ),
                GestureDetector(
                  //todo
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => TipDialog(
                          title: '十大流动地址',
                          content: '指该币种在7天内波动 （转入或者转出）数量最大的前10持币地址'),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      CupertinoIcons.question_circle,
                      size: 14,
                      color: Styles.cSub(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DataGridView(
            list: logic.flowAddressList,
          ),
          const Gap(10),
          Divider(height: 8, thickness: 8, color: Theme.of(context).cardColor),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: Text(
              '前100持币地址明细',
              style: Styles.tsBody_16m(context),
            ),
          ),
          DataGridView(
            list: logic.topAddressList,
            showChange: false,
          ),
        ],
      ),
    );
  }
}
