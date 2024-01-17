import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/modules/home/price_change/price_change_view.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'contract_logic.dart';

class ContractPage extends StatelessWidget {
  const ContractPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(ContractLogic());
    final state = Get.find<ContractLogic>().state;
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
                onTap: () => Get.toNamed(RouteConfig.contractSearch),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  height: state.isScrollDown.value ? 32 : 0,
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
          GetBuilder<ContractLogic>(
              id: 'sort',
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                  child: Row(
                    children: [
                      SortWithArrow(
                        title: S.current.s_oi_vol,
                        status: state.oiSort,
                        onTap: () => logic.tapSort(SortType.openInterest),
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
                        status: state.oiChangeSort,
                        onTap: () => logic.tapSort(SortType.openInterestCh24),
                      ),
                      const Spacer(),
                      SortWithArrow(
                        title: S.current.s_price,
                        status: state.priceSort,
                        onTap: () => logic.tapSort(SortType.price),
                      ),
                      // const Gap(30),
                      Container(
                        width: 100,
                        alignment: Alignment.centerRight,
                        child: SortWithArrow(
                          title: S.current.s_price_chg,
                          status: state.priceChangSort,
                          onTap: () => logic.tapSort(SortType.priceChangeH24),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          Obx(() {
            return state.isLoading.value
                ? const LottieIndicator(
                    margin: EdgeInsets.only(top: 200),
                  )
                : Expanded(
                    child: EasyRefresh(
                      onRefresh: logic.onRefresh,
                      child: GetBuilder<ContractLogic>(
                          id: 'data',
                          builder: (_) {
                            return SlidableAutoCloseBehavior(
                              child: ListView.builder(
                                controller: state.scrollController,
                                padding: const EdgeInsets.only(bottom: 10),
                                itemBuilder: (cnt, idx) {
                                  MarkerTickerEntity item = state.data[idx];
                                  return _DataItem(
                                    key: ValueKey(idx),
                                    item: item,
                                    logic: logic,
                                  );
                                },
                                itemCount: state.data.length ?? 0,
                              ),
                            );
                          }),
                    ),
                  );
          }),
        ],
      ),
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
    Color normalColor = Theme.of(context).textTheme.bodyMedium!.color!;
    Color animationColor = normalColor;
    final old = logic.state.oldData.firstWhere(
        (element) => item.baseCoin == element.baseCoin,
        orElse: () => MarkerTickerEntity());
    animationColor = old.price != null
        ? item.price! > old.price!
            ? Styles.cUp(context)
            : item.price! < old.price!
                ? Styles.cDown(context)
                : normalColor
        : normalColor;
    return Slidable(
      key: key,
      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const ScrollMotion(),
        children: [
          CustomSlidableAction(
            onPressed: (_) {
              if (logic.state.fetching.value) return;
              logic.state.fetching.value = true;
              logic
                  .tapCollect(item)
                  .then((value) => logic.state.fetching.value = false);
            },
            backgroundColor: Styles.cMain,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                item.follow == true
                    ? Image.asset(
                        Assets.commonIconStarFill,
                        width: 15,
                        height: 15,
                        color: Colors.white,
                      )
                    : Image.asset(
                        Assets.commonIconStar,
                        width: 15,
                        height: 15,
                        color: Colors.white,
                      ),
                const Gap(4),
                Text(
                  item.follow == true ? S.current.s_del_star : S.current.s_add_star,
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
          ),
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
                child: AnimationColorText(
                  text: '\$${item.price}',
                  style: Styles.tsBody_16m(context),
                  normalColor: normalColor,
                  animationColor: animationColor,
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
