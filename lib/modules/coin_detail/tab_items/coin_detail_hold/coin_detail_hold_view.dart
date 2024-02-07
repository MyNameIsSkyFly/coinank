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
              S.of(context).householdsTrending,
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
                  S.of(context).top10FlowingAddress,
                  style: Styles.tsBody_16m(context),
                ),
                GestureDetector(
                  //todo
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => TipDialog(
                          title: S.of(context).top10FlowingAddress,
                          content: S.of(context).top10FlowingAddressIntro),
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
              S.of(context).top100AddressDetail,
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
