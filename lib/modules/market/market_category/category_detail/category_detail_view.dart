import 'package:ank_app/modules/market/contract/contract_coin/contract_coin_logic.dart';
import 'package:ank_app/modules/market/contract/contract_coin/widgets/customize_filter_header_view.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../contract/contract_coin/widgets/contract_coin_grid_view.dart';
import 'category_detail_logic.dart';

class CategoryDetailPage extends StatefulWidget {
  const CategoryDetailPage({super.key});

  static const String routeName = '/market/category_detail';

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(CategoryDetailLogic());
  String? tag;

  @override
  void initState() {
    tag = Get.arguments['tag'];
    logic.tabCtrl = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).marketCategory)),
      body: Column(
        children: [
          TabBar(
            controller: logic.tabCtrl,
            tabs: [
              Tab(text: S.of(context).derivatives),
              Tab(text: S.of(context).spot),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: logic.tabCtrl,
              children: [
                AliveWidget(child: _Contract(tag: tag)),
                AliveWidget(child: _Spot()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Contract extends StatefulWidget {
  const _Contract({super.key, this.tag});

  final String? tag;

  @override
  State<_Contract> createState() => _ContractState();
}

class _ContractState extends State<_Contract> {
  final logic = ContractCoinLogic();

  @override
  void initState() {
    logic.tag = widget.tag;
    logic.onInit();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _Contract oldWidget) {
    if (oldWidget.tag != widget.tag) {
      logic.tag = widget.tag;
      logic.onRefresh();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    logic.onClose();
    super.dispose();
  }

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

class _Spot extends StatelessWidget {
  const _Spot({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
