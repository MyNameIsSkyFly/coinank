import 'package:ank_app/entity/news_entity.dart';
import 'package:ank_app/modules/news/widget/news_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../res/export.dart';

class NewsDetailPage extends StatefulWidget {
  const NewsDetailPage({super.key});

  static const routeName = '/news-detail';

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  late String id;
  late NewsType type;
  var detail = const NewsEntity();
  final recommendList = RxList<NewsEntity>();

  @override
  void initState() {
    var arguments = Get.arguments as Map<String, dynamic>;
    id = arguments['id'];
    type = arguments['type'];
    _getNewsDetail();
    super.initState();
  }

  void _getNewsDetail() {
    Apis().getNewsDetail(id: id).then((value) {
      setState(() => detail = value ?? const NewsEntity());
      _getRecommendNews();
    });
  }

  void _getRecommendNews() {
    Apis()
        .getNewsList(
            isPopular: true,
            type: 2,
            page: 1,
            pageSize: 5,
            lang: AppUtil.shortLanguageName)
        .then((value) {
      recommendList.assignAll(value ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(switch (type) {
          NewsType.recommend => S.of(context).recommend,
          NewsType.fast => S.of(context).fastNews,
          NewsType.normal => S.of(context).news,
        }),
        actions: [
          IconButton(
              onPressed: () => AppUtil.shareImage(),
              icon: const ImageIcon(AssetImage(Assets.commonIcShare)))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
            sliver: Text(
              detail.title ?? '',
              style: Styles.tsBody_20(context).medium,
            ).sliverBox,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  if (detail.sourceWeb != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: ImageUtil.newsLogo(detail.sourceWeb ?? '',
                          size: 15, isCircle: true),
                    ),
                  Text(detail.sourceWeb ?? '', style: Styles.tsSub_12(context)),
                  const Gap(20),
                  Expanded(child: Builder(builder: (context) {
                    if (detail.ts == null) return const SizedBox();
                    late String dateStr;
                    final date =
                        DateTime.fromMillisecondsSinceEpoch(detail.ts ?? 0);
                    final now = DateTime.now();
                    if (now.difference(date).inMinutes <= 1) {
                      dateStr = '刚刚';
                    } else if (now.difference(date).inMinutes <= 60) {
                      dateStr = S
                          .of(context)
                          .xMinutesAgo(now.difference(date).inMinutes);
                    } else if (now.difference(date).inHours <= 24) {
                      dateStr =
                          S.of(context).xHoursAgp(now.difference(date).inHours);
                    } else if (now.difference(date).inDays <= 7) {
                      dateStr =
                          S.of(context).xDaysAgo(now.difference(date).inDays);
                    } else {
                      dateStr = DateFormat('yyyy-MM-dd').format(date);
                    }
                    return Text(dateStr, style: Styles.tsSub_12(context));
                  })),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 40),
            sliver: HtmlWidget(detail.content ?? '',
                    textStyle: Styles.tsBody_14(context).copyWith(height: 2))
                .sliverBox,
          ),
          Obx(() {
            return SliverVisibility(
              visible: recommendList.isNotEmpty,
              sliver: SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                sliver: SliverToBoxAdapter(
                    child: Text(
                  S.of(context).recommend,
                  style: Styles.tsBody_20(context).medium,
                )),
              ),
            );
          }),
          Obx(() {
            return SliverList.builder(
              itemCount: recommendList.length,
              itemBuilder: (context, index) {
                return NewsItem(recommendList[index], type: NewsType.recommend);
              },
            );
          }),
          const SliverGap(50),
        ],
      ),
    );
  }
}
