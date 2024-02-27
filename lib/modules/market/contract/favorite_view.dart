import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/modules/home/home_search/home_search_view.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../../widget/animated_color_text.dart';
import 'contract_logic.dart';
import 'contract_state.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final logic = Get.put(ContractLogic());
  final state = Get.find<ContractLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return AnimatedSize(
              duration: const Duration(milliseconds: 100),
              alignment: Alignment.topCenter,
              child: InkWell(
                onTap: () => Get.toNamed(HomeSearchPage.routeName),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  height: state.isScrollDownF.value ? 32 : 0,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.commonIconSearch,
                        width: 16,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      const Gap(10),
                      Text(
                        S.current.s_search,
                        style: Styles.tsSub_12(context),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
            child: Obx(() {
              return state.isLoading.value || state.favoriteData.isEmpty
                  ? const SizedBox()
                  : Row(
                      children: [
                        SortWithArrow(
                          title: S.current.s_oi_vol,
                          status: state.favoriteOiSort.value,
                          onTap: () {
                            state.favoriteOiSort.value =
                                state.favoriteOiSort.value == SortStatus.down
                                    ? SortStatus.up
                                    : SortStatus.down;
                            state.favoritePriceSort.value = SortStatus.normal;
                            state.favoritePriceChangeSort.value =
                                SortStatus.normal;
                            state.favoriteOiChangeSort.value =
                                SortStatus.normal;
                            logic.sortFavorite(type: SortType.openInterest);
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
                          status: state.favoriteOiChangeSort.value,
                          onTap: () {
                            state.favoriteOiChangeSort.value =
                                state.favoriteOiChangeSort.value ==
                                        SortStatus.normal
                                    ? SortStatus.down
                                    : state.favoriteOiChangeSort.value ==
                                            SortStatus.down
                                        ? SortStatus.up
                                        : SortStatus.normal;
                            state.favoritePriceSort.value = SortStatus.normal;
                            state.favoritePriceChangeSort.value =
                                SortStatus.normal;
                            state.favoriteOiSort.value = SortStatus.normal;

                            if (state.favoriteOiChangeSort.value ==
                                SortStatus.normal) {
                              state.favoriteOiSort.value = SortStatus.down;
                            }
                            logic.sortFavorite(type: SortType.openInterestCh24);
                          },
                        ),
                        const Spacer(),
                        SortWithArrow(
                          title: S.current.s_price,
                          status: state.favoritePriceSort.value,
                          onTap: () {
                            state.favoritePriceSort.value =
                                state.favoritePriceSort.value ==
                                        SortStatus.normal
                                    ? SortStatus.down
                                    : state.favoritePriceSort.value ==
                                            SortStatus.down
                                        ? SortStatus.up
                                        : SortStatus.normal;
                            state.favoritePriceChangeSort.value =
                                SortStatus.normal;
                            state.favoriteOiSort.value = SortStatus.normal;
                            state.favoriteOiChangeSort.value =
                                SortStatus.normal;
                            if (state.favoritePriceSort.value ==
                                SortStatus.normal) {
                              state.favoriteOiSort.value = SortStatus.down;
                            }
                            logic.sortFavorite(type: SortType.price);
                          },
                        ),
                        // const Gap(30),
                        Container(
                          width: 100,
                          alignment: Alignment.centerRight,
                          child: SortWithArrow(
                            title: S.current.s_price_chg,
                            status: state.favoritePriceChangeSort.value,
                            onTap: () {
                              state.favoritePriceChangeSort.value =
                                  state.favoritePriceChangeSort.value ==
                                          SortStatus.normal
                                      ? SortStatus.down
                                      : state.favoritePriceChangeSort.value ==
                                              SortStatus.down
                                          ? SortStatus.up
                                          : SortStatus.normal;
                              state.favoritePriceSort.value = SortStatus.normal;
                              state.favoriteOiSort.value = SortStatus.normal;
                              state.favoriteOiChangeSort.value =
                                  SortStatus.normal;
                              if (state.favoritePriceChangeSort.value ==
                                  SortStatus.normal) {
                                state.favoriteOiSort.value = SortStatus.down;
                              }
                              logic.sortFavorite(type: SortType.priceChangeH24);
                            },
                          ),
                        ),
                      ],
                    );
            }),
          ),
          Expanded(child: Obx(() {
            return IndexedStack(
              index: state.isLoading.value
                  ? 0
                  : state.favoriteData.isEmpty
                      ? 1
                      : 2,
              children: [
                Visibility(
                    visible: state.isLoading.value,
                    child: const LottieIndicator(
                        margin: EdgeInsets.only(top: 200))),
                _EmptyView(state: state, logic: logic),
                EasyRefresh(
                  // scrollBehaviorBuilder: (physics) =>
                  //     const ERScrollBehavior(ClampingScrollPhysics()),
                  onRefresh: logic.onRefreshF,
                  child: SlidableAutoCloseBehavior(
                    child: ListView.builder(
                      // physics: const ClampingScrollPhysics(),
                      controller: state.scrollControllerF,
                      padding: const EdgeInsets.only(bottom: 10),
                      itemBuilder: (cnt, idx) {
                        MarkerTickerEntity item = state.favoriteData[idx];
                        return _DataItem(
                          key: ValueKey(idx),
                          item: item,
                          logic: logic,
                        );
                      },
                      itemCount: state.favoriteData.length,
                    ),
                  ),
                )
              ],
            );
          })),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({
    required this.state,
    required this.logic,
  });

  final ContractState state;
  final ContractLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          itemCount: state.fixedCoin.length,
          padding: const EdgeInsets.all(15).copyWith(top: 0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 72,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15),
          itemBuilder: (context, index) {
            return StatefulBuilder(builder: (context, setState) {
              return GestureDetector(
                onTap: () {
                  if (state.selectedFixedCoin
                      .contains(state.fixedCoin[index])) {
                    state.selectedFixedCoin.remove(state.fixedCoin[index]);
                  } else {
                    state.selectedFixedCoin.add(state.fixedCoin[index]);
                  }
                  setState(() {});
                },
                child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(() {
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.fixedCoin[index],
                                  style: Styles.tsBody_16(context).medium,
                                ),
                                Text(
                                  S.of(context).s_swap,
                                  style: Styles.tsSub_12(context),
                                ),
                              ],
                            ),
                          ),
                          if (state.selectedFixedCoin
                              .contains(state.fixedCoin[index]))
                            const Icon(CupertinoIcons.checkmark_alt_circle,
                                color: Styles.cMain)
                          else
                            Icon(CupertinoIcons.circle,
                                color: Styles.cSub(context).withOpacity(0.5))
                        ],
                      );
                    })),
              );
            });
          },
        ),
        const Gap(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Obx(() {
            return FilledButton(
                onPressed: state.selectedFixedCoin.isEmpty
                    ? null
                    : () {
                        if (state.fetching.value) return;
                        state.fetching.value = true;
                        logic
                            .saveFixedCoin()
                            .whenComplete(() => state.fetching.value = false);
                      },
                child: Text(S.of(context).addToFavorite));
          }),
        )
      ],
    );
  }
}

class _DataItem extends StatelessWidget {
  const _DataItem({
    super.key,
    required this.item,
    required this.logic,
  });

  final MarkerTickerEntity item;
  final ContractLogic logic;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const ScrollMotion(),
        children: [
          Obx(() {
            return CustomSlidableAction(
              autoClose: !logic.state.fetching.value,
              onPressed: (_) {
                if (logic.state.fetching.value) return;
                logic.state.fetching.value = true;
                logic
                    .tapFavoriteCollect(item.baseCoin)
                    .then((value) => logic.state.fetching.value = false);
              },
              backgroundColor: Styles.cMain,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Assets.commonIconStarFill,
                    width: 15,
                    height: 15,
                    color: Colors.white,
                  ),
                  const Gap(4),
                  Text(
                    S.current.s_del_star,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            );
          }),
        ],
      ),
      child: InkWell(
        onTap: () => logic.tapItem(item),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 55,
          child: Row(
            children: [
              ClipOval(
                child: ImageUtil.networkImage(
                  item.coinImage ?? '',
                  width: 24,
                  height: 24,
                ),
              ),
              const Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.baseCoin ?? '',
                    style: Styles.tsBody_14m(context),
                  ),
                  const Gap(5),
                  Row(
                    children: [
                      Text(
                        AppUtil.getLargeFormatString(
                            '${item.openInterest ?? 0}'),
                        style: Styles.tsSub_12(context),
                      ),
                      const Gap(5),
                      Text(
                        AppUtil.getRate(
                            rate: item.openInterestCh24, precision: 2),
                        style: TextStyle(
                          fontSize: 12,
                          color: (item.openInterestCh24 ?? 0) >= 0
                              ? Styles.cUp(context)
                              : Styles.cDown(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: AnimatedColorText(
                  text: '\$${item.price}',
                  value: item.price ?? 0,
                  style: Styles.tsBody_16m(context),
                  textAlign: TextAlign.right,
                ),
              ),
              const Gap(35),
              Container(
                width: 65,
                height: 27,
                decoration: BoxDecoration(
                  color: (item.priceChangeH24 ?? 0) >= 0
                      ? Styles.cUp(context)
                      : Styles.cDown(context),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppUtil.getRate(
                    rate: item.priceChangeH24,
                    precision: 2,
                    mul: false,
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
