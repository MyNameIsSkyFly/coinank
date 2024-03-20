import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/custom_underliner_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/category_detail_contract_view.dart';
import 'widgets/category_detail_spot_view.dart';

class CategoryDetailPage extends StatefulWidget {
  const CategoryDetailPage({super.key});

  static const String routeName = '/market/category_detail';

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController tabCtrl;
  String? tag;

  @override
  void initState() {
    tag = Get.arguments['tag'];
    tabCtrl = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).marketCategory)),
      body: Column(
        children: [
          SizedBox(
            height: 36,
            child: TabBar(
              isScrollable: true,
              labelStyle: Styles.tsBody_14m(context),
              unselectedLabelStyle: Styles.tsSub_14m(context),
              tabAlignment: TabAlignment.start,
              indicator: const CustomUnderlineTabIndicator.thin(),
              controller: tabCtrl,
              tabs: [
                Tab(text: S.of(context).derivatives),
                Tab(text: S.of(context).spot),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabCtrl,
              children: [
                AliveWidget(child: CategoryDetailContractView(tag: tag)),
                const AliveWidget(child: CategoryDetailSpotSpotView()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

