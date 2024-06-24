import 'dart:async';

import 'package:ank_app/entity/event/theme_event.dart';
import 'package:ank_app/entity/news_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/app_paged_list_view.dart';
import 'package:ank_app/widget/app_refresh.dart';
import 'package:ank_app/widget/infinity_paging_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'news_item.dart';

class NewsListView extends StatefulWidget {
  const NewsListView(
      {super.key, required this.isRecommended, required this.isFast});

  final bool isRecommended;
  final bool isFast;

  @override
  State<NewsListView> createState() => _NewsListViewState();
}

class _NewsListViewState extends State<NewsListView>
    with AutomaticKeepAliveClientMixin {
  final _pageSize = 10;
  final _pagingCtrl = AppPagingController<int, NewsEntity>(firstPageKey: 1);

  final list = RxList<NewsEntity>();
  StreamSubscription? _localeChangeSub;

  Completer<void>? _refreshCompleter;

  @override
  void initState() {
    _pagingCtrl.addPageRequestListener(_getNews);
    _localeChangeSub = AppConst.eventBus.on<ThemeChangeEvent>().listen((event) {
      if (event.type != ThemeChangeType.locale) return;
      _pagingCtrl.refresh();
    });
    super.initState();
  }

  Future<void> _getNews(int pageKey) async {
    if (pageKey == 1) _refreshCompleter = Completer();
    try {
      final newItems = (await Apis().getNewsList(
              page: pageKey,
              pageSize: _pageSize,
              type: widget.isFast ? 1 : 2,
              isPopular: widget.isRecommended,
              lang: AppUtil.shortLanguageName)) ??
          [];
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingCtrl.appendLastPage(newItems);
      } else {
        _pagingCtrl.appendPage(newItems, pageKey + 1);
      }
    } catch (e) {
      _pagingCtrl.error = e;
    }
    _refreshCompleter?.complete();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppRefresh(
      onRefresh: () async {
        _pagingCtrl.refresh();
        await _refreshCompleter?.future;
        _refreshCompleter = null;
      },
      child: AppPagedListView<int, NewsEntity>(
        pagingController: _pagingCtrl,
        itemBuilder: (context, item, index) {
          return NewsItem(item,
              type: widget.isRecommended
                  ? NewsType.recommend
                  : widget.isFast
                      ? NewsType.fast
                      : NewsType.normal);
        },
      ),
    );
  }

  @override
  void dispose() {
    _pagingCtrl.dispose();
    _localeChangeSub?.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
