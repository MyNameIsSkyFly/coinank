import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'contract_search_logic.dart';

class ContractSearchPage extends StatelessWidget {
  ContractSearchPage({super.key});

  final logic = Get.find<ContractSearchLogic>();
  final state = Get.find<ContractSearchLogic>().state;

  @override
  Widget build(BuildContext context) {
    return GestureDetectorWidget(
      child: Scaffold(
        appBar: AppTitleBar(
          customWidget: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    keyboardType:
                        const TextInputType.numberWithOptions(signed: true),
                    style: Styles.tsBody_16(context),
                    maxLines: 1,
                    inputFormatters: [
                      RegexFormatter(regex: RegexExpression.regexOnlyLetter),
                      LengthLimitingTextInputFormatter(10),
                      UpperCaseTextFormatter(),
                    ],
                    decoration: InputDecoration(
                      fillColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      filled: true,
                      constraints: const BoxConstraints(maxHeight: 40),
                      contentPadding: EdgeInsets.zero,
                      hintText: '搜索',
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
                    onChanged: (v) => logic.search(v),
                  ),
                ),
                InkWell(
                  onTap: Get.back,
                  child: SizedBox(
                    width: 62,
                    child: Center(
                      child: Text(
                        '取消',
                        style: Styles.tsSub_16(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15),
              height: 44,
              child: Row(
                children: [
                  Text('热门', style: Styles.tsBody_16m(context)),
                  Text('🔥', style: Styles.tsBody_16m(context)),
                ],
              ),
            ),
            Obx(() {
              return Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (cnt, idx) {
                    MarkerTickerEntity item = state.list[idx];
                    return _DataItem(item: item);
                  },
                  itemCount: state.list.length,
                ),
              );
            }),
          ],
        ),
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 47,
              height: 47,
              child: IconButton(
                onPressed: onTapCollect,
                visualDensity: VisualDensity.compact,
                icon: Image.asset(
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
            ),
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
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '\$${item.price}',
                  style: Styles.tsBody_14(context).copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const Gap(5),
                Text(
                  AppUtil.getRate(
                    rate: item.priceChangeH24,
                    precision: 2,
                    mul: false,
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: (item.priceChangeH24 ?? 0) >= 0
                        ? Styles.cUp(context)
                        : Styles.cDown(context),
                  ),
                ),
              ],
            ),
            const Gap(15),
          ],
        ),
      ),
    );
  }
}
