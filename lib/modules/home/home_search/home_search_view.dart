import 'package:ank_app/entity/search_v2_entity.dart';
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
      body: CustomScrollView(
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
                            //todo intl
                            '搜索历史',
                            style: Styles.tsBody_16m(context),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => logic.clearHistory(),
                          child: ImageIcon(
                              const AssetImage(Assets.commonIcClear),
                              color: Styles.cSub(context),
                              size: 16),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Obx(() {
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: logic.history
                            .map((element) => Container(
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
                                ))
                            .toList(),
                      );
                    })
                  ],
                ).sliverBox,
              );
            }),
          ),
          const SliverGap(30),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: Text(
              //todo intl
              '热门搜索',
              style: Styles.tsBody_16m(context),
            ).sliverBox,
          ),
          const SliverGap(10),
          Obx(() {
            return SliverList.builder(
              itemCount: logic.hot.length,
              itemBuilder: (context, index) {
                final item = logic.hot[index];
                return _Item(logic: logic, item: item, index: index);
              },
            );
          })
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    super.key,
    required this.logic,
    required this.item,
    required this.index,
  });

  final int index;
  final HomeSearchLogic logic;
  final SearchV2ItemEntity item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        await StoreLogic.to.saveTappedSearchResult(item);
        logic.initHistory();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text('${index + 1}', style: Styles.tsBody_16m(context)),
            ),
            ImageUtil.networkImage(AppConst.imageHost(item.baseCoin ?? ''),
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
                        AppUtil.getLargeFormatString('${item.oi}'),
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
              children: [
                Text('${item.price}', style: Styles.tsBody_14m(context)),
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
    if (type == null || type == SearchEntityType.BASECOIN)
      return const SizedBox();
    final color = switch (type) {
      SearchEntityType.ERC20 => Styles.cSub(context),
      SearchEntityType.BRC20 => const Color(0xffff8c21),
      SearchEntityType.ASC20 => Styles.cMain,
      _ => Colors.white
    };
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(2),
      ),
      child:
          Text(type?.name ?? '', style: TextStyle(color: color, fontSize: 10)),
    );
  }
}
