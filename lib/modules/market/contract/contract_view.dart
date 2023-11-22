import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contract_logic.dart';

class ContractPage extends StatelessWidget {
  const ContractPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(ContractLogic());
    final state = Get.find<ContractLogic>().state;
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Get.toNamed(RouteConfig.contractSearch),
            child: Container(
              height: 32,
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
          GetBuilder<ContractLogic>(
              id: 'sort',
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Image.asset(
                          Assets.commonIconStar,
                          width: 17,
                          height: 17,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                      const Gap(15),
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
                        width: 90,
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
          Expanded(
            child: EasyRefresh(
              refreshOnStart: true,
              onRefresh: logic.startTimer,
              child: GetBuilder<ContractLogic>(
                  id: 'data',
                  builder: (_) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 10),
                      itemBuilder: (cnt, idx) {
                        MarkerTickerEntity item = state.data!.list![idx];
                        return _DataItem(
                          item: item,
                          onTap: () => logic.tapItem(item),
                          onTapCollect: () => logic.tapCollect(item),
                        );
                      },
                      itemCount: state.data?.list?.length ?? 0,
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataItem extends StatelessWidget {
  const _DataItem({
    super.key,
    required this.item,
    this.onTap,
    this.onTapCollect,
  });

  final MarkerTickerEntity item;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapCollect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            InkWell(
              onTap: onTapCollect,
              child: Image.asset(
                Assets.commonIconStarFill,
                width: 17,
                height: 17,
                color: item.follow == true
                    ? Styles.cYellow
                    : Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .color!
                        .withOpacity(0.3),
              ),
            ),
            const Gap(15),
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
              children: [
                Text(
                  item.baseCoin ?? '',
                  style: Styles.tsBody_12m(context),
                ),
                const Gap(5),
                Row(
                  children: [
                    Text(
                      AppUtil.getLargeFormatString('${item.openInterest ?? 0}'),
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
              child: AutoSizeText(
                '\$${item.price}',
                style: Styles.tsBody_14(context).copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                maxFontSize: 14,
                minFontSize: 10,
                maxLines: 1,
                textAlign: TextAlign.right,
              ),
            ),
            const Gap(25),
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
    );
  }
}
