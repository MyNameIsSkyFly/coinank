import 'package:ank_app/modules/news/widget/news_list.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'news_logic.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(NewsLogic());
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        automaticallyImplyLeading: false,
        leadingWidth: double.infinity,
        leading: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Styles.cBody(context),
          unselectedLabelColor: Styles.cSub(context),
          labelStyle: Styles.tsBody_18m(context),
          unselectedLabelStyle: Styles.tsSub_18(context).medium,
          tabAlignment: TabAlignment.start,
          dividerColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          tabs: [
            Tab(text: S.of(context).recommend),
            Tab(text: S.of(context).fastNews),
            Tab(text: S.of(context).news),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: const [
        NewsListView(isRecommended: true, isFast: false),
        NewsListView(isRecommended: false, isFast: true),
        NewsListView(isRecommended: false, isFast: false),
      ]),
    );
  }
}
