import 'dart:math';

import 'package:ank_app/entity/search_v2_entity.dart';
import 'package:ank_app/modules/market/contract/contract_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/rate_with_sign.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'home_search_logic.dart';

class HomeSearchPage extends StatelessWidget {
  HomeSearchPage({super.key});

  static const routeName = '/search';

  final logic = Get.put(HomeSearchLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitleBar(
        customWidget: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  textInputAction: TextInputAction.search,
                  style: Styles.tsBody_16(context),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    UpperCaseTextFormatter(),
                  ],
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                    filled: true,
                    constraints: const BoxConstraints(maxHeight: 40),
                    contentPadding: EdgeInsets.zero,
                    hintText: S.current.s_search,
                    hintStyle: Styles.tsSub_14(context),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 10),
                      child: Image.asset(
                        Assets.commonIconSearch,
                        width: 16,
                        height: 16,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(maxWidth: 40),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) logic.keyword.value = '';
                  },
                  onSubmitted: (v) => logic.search(v),
                ),
              ),
              InkWell(
                onTap: Get.back,
                child: SizedBox(
                  width: 62,
                  child: Center(
                    child: Text(
                      S.current.s_cancel,
                      style: Styles.tsSub_16(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        return IndexedStack(
          index: logic.keyword.value.isEmpty ? 0 : 1,
          children: [
            _DefaultView(logic: logic),
            _ResultView(logic: logic),
          ],
        );
      }),
    );
  }
}

class _ResultView extends StatefulWidget {
  const _ResultView({super.key, required this.logic});

  final HomeSearchLogic logic;

  @override
  State<_ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<_ResultView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 6, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          controller: tabController,
          labelPadding: const EdgeInsets.symmetric(horizontal: 10),
          labelStyle: Styles.tsBody_14m(context),
          unselectedLabelStyle: Styles.tsSub_14m(context),
          tabs: [
            Tab(text: S.current.s_all),
            Tab(text: S.of(context).spotOrContract),
            const Tab(text: 'BRC20'),
            const Tab(text: 'ERC20'),
            const Tab(text: 'ARC20'),
            const Tab(text: 'ASC20'),
          ],
        ),
        Expanded(
            child: TabBarView(controller: tabController, children: [
          _SummaryView(logic: widget.logic, tabController: tabController),
          Obx(() => _TabItemView(
              list: widget.logic.baseList.value, logic: widget.logic)),
          Obx(() => _TabItemView(
              list: widget.logic.brcList.value, logic: widget.logic)),
          Obx(() => _TabItemView(
              list: widget.logic.ercList.value, logic: widget.logic)),
          Obx(() => _TabItemView(
              list: widget.logic.arcList.value, logic: widget.logic)),
          Obx(() => _TabItemView(
              list: widget.logic.ascList.value, logic: widget.logic)),
        ]))
      ],
    );
  }
}

class _SummaryView extends StatelessWidget {
  const _SummaryView({
    super.key,
    required this.logic,
    required this.tabController,
  });

  final HomeSearchLogic logic;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      _AllItem(logic.baseList,
          title: S.of(context).spotOrContract,
          logic: logic,
          tabController: tabController,
          tabIndex: 1),
      _AllItem(
        logic.brcList,
        title: 'BRC20',
        logic: logic,
        tabController: tabController,
        tabIndex: 2,
      ),
      _AllItem(
        logic.ercList,
        title: 'ERC20',
        logic: logic,
        tabController: tabController,
        tabIndex: 3,
      ),
      _AllItem(
        logic.arcList,
        title: 'ARC20',
        logic: logic,
        tabController: tabController,
        tabIndex: 4,
      ),
      _AllItem(
        logic.ascList,
        title: 'ASC20',
        logic: logic,
        tabController: tabController,
        tabIndex: 5,
      ),
      const SliverGap(100),
    ]);
  }
}

class _AllItem extends StatelessWidget {
  const _AllItem(
    this.list, {
    required this.logic,
    required this.tabController,
    required this.title,
    required this.tabIndex,
  });

  final String title;
  final int tabIndex;
  final RxList<SearchV2ItemEntity> list;

  final TabController tabController;
  final HomeSearchLogic logic;

  @override
  Widget build(BuildContext context) {
    return SliverVisibility(
      visible: list.isNotEmpty,
      sliver: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(title, style: Styles.tsBody_16m(context)),
          ),
          const Gap(10),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: min(3, list.length),
            itemBuilder: (context, index) =>
                _Item(logic: logic, item: list[index], index: index),
          ),
          const Gap(10),
          if (list.length > 3)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).dividerTheme.color,
                ),
                onPressed: () {
                  tabController.animateTo(tabIndex,
                      duration: const Duration(milliseconds: 50));
                },
                child: Text(
                  S.of(context).viewMore,
                  style: Styles.tsBody_16(context),
                )),
          ),
          const Gap(10),
        ],
      ).sliverBox,
    );
  }
}

class _TabItemView extends StatefulWidget {
  const _TabItemView({super.key, required this.list, required this.logic});

  final List<SearchV2ItemEntity> list;
  final HomeSearchLogic logic;

  @override
  State<_TabItemView> createState() => _TabItemViewState();
}

class _TabItemViewState extends State<_TabItemView>
    with AutomaticKeepAliveClientMixin {
  final favoriteOiSort = SortStatus.down.obs;
  final favoritePriceSort = SortStatus.normal.obs;
  final favoritePriceChangeSort = SortStatus.normal.obs;
  final favoriteOiChangeSort = SortStatus.normal.obs;
  final list = <SearchV2ItemEntity>[];
  String favoriteSortBy = 'openInterest';
  String favoriteSortType = 'descend';

  @override
  void initState() {
    list.addAll(widget.list);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _TabItemView oldWidget) {
    list.clear();
    list.addAll(widget.list);
    favoriteOiSort.value = SortStatus.down;
    favoritePriceSort.value = SortStatus.normal;
    favoritePriceChangeSort.value = SortStatus.normal;
    favoriteOiChangeSort.value = SortStatus.normal;
    favoriteSortBy = 'openInterest';
    favoriteSortType = 'descend';
    super.didUpdateWidget(oldWidget);
  }

  void sortFavorite({SortType? type}) {
    if (type != null) favoriteSortBy = type.name;
    list.sort(
      (a, b) {
        if (favoriteSortBy == 'openInterestCh24') {
          if (favoriteOiChangeSort.value == SortStatus.normal) {
            return (b.oi ?? 0).compareTo((a.oi ?? 0));
          }
          var result = (b.oiChg ?? 0).compareTo((a.oiChg ?? 0));
          return favoriteOiChangeSort.value != SortStatus.down
              ? -result
              : result;
        } else if (favoriteSortBy == 'price') {
          if (favoritePriceSort.value == SortStatus.normal) {
            return (b.oi ?? 0).compareTo((a.oi ?? 0));
          }
          var result = (b.price ?? 0).compareTo((a.price ?? 0));
          return favoritePriceSort.value != SortStatus.down ? -result : result;
        } else if (favoriteSortBy == 'priceChangeH24') {
          if (favoritePriceChangeSort.value == SortStatus.normal) {
            return (b.oi ?? 0).compareTo((a.oi ?? 0));
          }
          var result = (b.priceChg ?? 0).compareTo((a.priceChg ?? 0));
          return favoritePriceChangeSort.value != SortStatus.down
              ? -result
              : result;
        }
        var result = (b.oi ?? 0).compareTo((a.oi ?? 0));
        return favoriteOiSort.value != SortStatus.down ? -result : result;
      },
    );
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (list.isEmpty) {
      return Column(
        children: [
          const Gap(170),
          Image.asset(Assets.commonIcEmptyBox, height: 68, width: 68),
          Opacity(
              opacity: 0.3,
              child: Text(S.of(context).s_none_data,
                  style: Styles.tsSub_14(context)))
        ],
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
          child: Row(
            children: [
              Text('Coin/', style: Styles.tsSub_12m(context)),
              SortWithArrow(
                title: S.current.s_oi_vol,
                status: favoriteOiSort.value,
                onTap: () {
                  favoriteOiSort.value = favoriteOiSort.value == SortStatus.down
                      ? SortStatus.up
                      : SortStatus.down;
                  favoritePriceSort.value = SortStatus.normal;
                  favoritePriceChangeSort.value = SortStatus.normal;
                  favoriteOiChangeSort.value = SortStatus.normal;
                  sortFavorite(type: SortType.openInterest);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  '/',
                  style: Styles.tsSub_12m(context),
                ),
              ),
              SortWithArrow(
                title: S.current.s_oi_chg,
                status: favoriteOiChangeSort.value,
                onTap: () {
                  favoriteOiChangeSort.value =
                      favoriteOiChangeSort.value == SortStatus.normal
                          ? SortStatus.down
                          : favoriteOiChangeSort.value == SortStatus.down
                              ? SortStatus.up
                              : SortStatus.normal;
                  favoritePriceSort.value = SortStatus.normal;
                  favoritePriceChangeSort.value = SortStatus.normal;
                  favoriteOiSort.value = SortStatus.normal;

                  if (favoriteOiChangeSort.value == SortStatus.normal) {
                    favoriteOiSort.value = SortStatus.down;
                  }
                  sortFavorite(type: SortType.openInterestCh24);
                },
              ),
              const Spacer(),
              SortWithArrow(
                title: S.current.s_price,
                status: favoritePriceSort.value,
                onTap: () {
                  favoritePriceSort.value =
                      favoritePriceSort.value == SortStatus.normal
                          ? SortStatus.down
                          : favoritePriceSort.value == SortStatus.down
                              ? SortStatus.up
                              : SortStatus.normal;
                  favoritePriceChangeSort.value = SortStatus.normal;
                  favoriteOiSort.value = SortStatus.normal;
                  favoriteOiChangeSort.value = SortStatus.normal;
                  if (favoritePriceSort.value == SortStatus.normal) {
                    favoriteOiSort.value = SortStatus.down;
                  }
                  sortFavorite(type: SortType.price);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  '/',
                  style: Styles.tsSub_12m(context),
                ),
              ),
              SortWithArrow(
                title: S.current.s_price_chg,
                status: favoritePriceChangeSort.value,
                onTap: () {
                  favoritePriceChangeSort.value =
                      favoritePriceChangeSort.value == SortStatus.normal
                          ? SortStatus.down
                          : favoritePriceChangeSort.value == SortStatus.down
                              ? SortStatus.up
                              : SortStatus.normal;
                  favoritePriceSort.value = SortStatus.normal;
                  favoriteOiSort.value = SortStatus.normal;
                  favoriteOiChangeSort.value = SortStatus.normal;
                  if (favoritePriceChangeSort.value == SortStatus.normal) {
                    favoriteOiSort.value = SortStatus.down;
                  }
                  sortFavorite(type: SortType.priceChangeH24);
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) => _Item(
                logic: widget.logic, item: list[index], index: index),
          ),
        )
      ],
    );
  }
}

class _DefaultView extends StatelessWidget {
  const _DefaultView({
    super.key,
    required this.logic,
  });

  final HomeSearchLogic logic;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverGap(10),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: Obx(() {
            return SliverVisibility(
              visible: logic.history.isNotEmpty,
              sliver: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          S.of(context).searchHistory,
                          style: Styles.tsBody_16m(context),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => logic.clearHistory(),
                        child: ImageIcon(const AssetImage(Assets.commonIcClear),
                            color: Styles.cSub(context), size: 16),
                      ),
                    ],
                  ),
                  const Gap(10),
                  Obx(() {
                    return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: logic.history
                          .map((element) => GestureDetector(
                                onTap: () => logic.onTapItem(element),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(element.baseCoin ?? ''),
                                      _Tag(type: element.tag),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  }),
                  const Gap(30),
                ],
              ).sliverBox,
            );
          }),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: Text(
            S.of(context).searchTrending,
            style: Styles.tsBody_16m(context),
          ).sliverBox,
        ),
        const SliverGap(10),
        Obx(() {
          return SliverList.builder(
            itemCount: logic.hot.length,
            itemBuilder: (context, index) {
              final item = logic.hot[index];
              return _Item(
                  logic: logic, item: item, index: index, showIndex: true);
            },
          );
        }),
        const SliverGap(50),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    super.key,
    required this.logic,
    required this.item,
    required this.index,
    this.showIndex = false,
  });

  final int index;
  final HomeSearchLogic logic;
  final SearchV2ItemEntity item;
  final bool showIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => logic.onTapItem(item),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            if (item.tag == SearchEntityType.BASECOIN)
              GestureDetector(
                onTap: () {
                  if (logic.marked.contains(item)) {
                    logic.unMark(item);
                } else {
                  logic.mark(item);
                }
              },
              child: Obx(() {
                return Icon(
                  Icons.star_rounded,
                  color: logic.marked.contains(item)
                      ? Styles.cYellow
                      : Styles.cSub(context).withOpacity(0.3),
                );
              }),
            ),
            if (showIndex)
              SizedBox(
                  width: 40,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                  child: Text(
                    '${index + 1}',
                    style: Styles.tsBody_16m(context),
                    textAlign: TextAlign.center,
                  ),
                  )),
            if (!showIndex && item.tag == SearchEntityType.BASECOIN)
              const Gap(15),
            ImageUtil.networkImage(
                item.tag == SearchEntityType.BASECOIN
                    ? AppConst.imageHost(item.baseCoin ?? '')
                    : 'https://cdn01.coinank.com/image/coin/${item.tag?.name.toLowerCase()}/brc-${item.baseCoin}.png',
                errorWidget: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.white24),
                        shape: BoxShape.circle),
                    child: Text(
                      '${item.baseCoin?.substring(0, 1)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800),
                    )),
                width: 24, height: 24),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(item.baseCoin ?? '',
                          style: Styles.tsBody_14m(context)),
                      _Tag(type: item.tag),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        AppUtil.getLargeFormatString('${item.oi ?? 0}'),
                        style: Styles.tsSub_12m(context),
                      ),
                      const Gap(5),
                      RateWithSign(rate: (item.oiChg ?? 0) * 100),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${item.price ?? 0}', style: Styles.tsBody_14m(context)),
                RateWithSign(rate: item.priceChg ?? 0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({super.key, this.type});

  final SearchEntityType? type;

  @override
  Widget build(BuildContext context) {
    if (type == null || type == SearchEntityType.BASECOIN) {
      return const SizedBox();
    }
    final color = switch (type) {
      SearchEntityType.ERC20 => Styles.cSub(context),
      SearchEntityType.BRC20 => const Color(0xffff8c21),
      SearchEntityType.ASC20 => Styles.cMain,
      SearchEntityType.ARC20 => Colors.deepOrange,
      _ => Colors.white
    };
    return Container(
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(2),
      ),
      child:
          Text(type?.name ?? '', style: TextStyle(color: color, fontSize: 10)),
    );
  }
}
