import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/custom_underliner_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contract_logic.dart';

class ContractPage extends StatefulWidget {
  const ContractPage({super.key});

  @override
  State<ContractPage> createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  final logic = Get.put(ContractLogic());

  final state = Get.find<ContractLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppTitleBar(
        customWidget: TabBar(
          tabAlignment: TabAlignment.start,
          controller: state.tabController,
          isScrollable: true,
          labelPadding: const EdgeInsets.only(left: 15, right: 5),
          labelColor: Theme.of(context).textTheme.bodyMedium?.color,
          labelStyle: Styles.tsBody_16m(context),
          unselectedLabelStyle: Styles.tsBody_16m(context),
          unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: const CustomUnderlineTabIndicator(),
          dividerColor: Theme.of(context).dividerTheme.color,
          tabs: [
            Tab(text: S.of(context).s_favorite),
            Tab(text: S.of(context).s_crypto_coin_short),
            Tab(text: S.of(context).s_oi),
            // Tab(text: S.of(context).s_futures_market),
            Tab(text: S.of(context).s_rekt),
            Tab(text: S.of(context).s_funding_rate),
          ],
        ),
      ),
      body: TabBarView(
        controller: state.tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: state.tabPage,
      ),
    );
  }
}
