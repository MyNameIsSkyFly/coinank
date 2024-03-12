import 'dart:io';

import 'package:ank_app/entity/oi_entity.dart';
import 'package:ank_app/modules/market/contract/contract_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../constants/urls.dart';
import 'exchange_oi_logic.dart';

class ExchangeOiPage extends StatelessWidget {
  const ExchangeOiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(ExchangeOiLogic(
        baseCoin: Get.find<ContractLogic>().state.exchangeOIBaseCoin));
    return Scaffold(
      body: Obx(() {
        if (logic.loading.value) {
          return const LottieIndicator();
        } else {
          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 44,
                child: Row(
                  children: [
                    Expanded(child: _CoinListView(logic: logic)),
                    InkWell(
                      onTap: () => logic.toSearch(),
                      child: Container(
                        padding: const EdgeInsets.only(left: 8),
                        color: Theme.of(context).colorScheme.tertiary,
                        width: 39,
                        height: 24,
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          Assets.commonIcLinesSearch,
                          width: 16,
                          height: 16,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: EasyRefresh(
                  onRefresh: () async => logic.onRefresh(),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DefaultTextStyle(
                          style: Styles.tsSub_12(context),
                          child: Row(
                            children: [
                              const Gap(15),
                              Expanded(
                                  flex: 10,
                                  child: Text(S.of(context).s_exchange_name)),
                              Expanded(
                                  flex: 9, child: Text(S.of(context).s_oi)),
                              Expanded(
                                  flex: 9, child: Text(S.of(context).s_rate)),
                              Expanded(
                                  flex: 6,
                                  child: Text(
                                    S.of(context).s_24h_chg,
                                    textAlign: TextAlign.end,
                                  )),
                              const Gap(15),
                            ],
                          ),
                        ),
                        Obx(() {
                          return Column(
                            children: logic.oiList.mapIndexed(
                              (index, element) {
                                final item = logic.oiList[index];
                                return _OiItem(
                                  item: item,
                                  baseCoin:
                                      logic.menuParamEntity.value.baseCoin ??
                                          '',
                                );
                              },
                            ).toList(),
                          );
                        }),
                        const Gap(24),
                        Obx(() {
                          return Row(
                            children: [
                              const Gap(15),
                              Expanded(
                                child: Text(
                                  '${S.of(context).s_exchange_oi}(${logic.menuParamEntity.value.baseCoin})',
                                  style: Styles.tsBody_14m(context),
                                ),
                              ),
                              const Gap(10),
                              _FilterChip(
                                  onTap: () async {
                                    final result = await logic
                                        .openSelector(logic.exchangeItems);
                                    if (result != null &&
                                        result.toLowerCase() !=
                                            logic.menuParamEntity.value.exchange
                                                ?.toLowerCase()) {
                                      logic.menuParamEntity.value.exchange =
                                          result;
                                      logic.updateChart();
                                      logic.menuParamEntity.refresh();
                                    }
                                  },
                                  text: logic.menuParamEntity.value.exchange),
                              const Gap(10),
                              _FilterChip(
                                  onTap: () async {
                                    final result = await logic
                                        .openSelector(logic.intervalItems);
                                    if (result != null &&
                                        result.toLowerCase() !=
                                            logic.menuParamEntity.value.interval
                                                ?.toLowerCase()) {
                                      logic.menuParamEntity.value.interval =
                                          result;
                                      logic.loadOIData();
                                      logic.menuParamEntity.refresh();
                                    }
                                  },
                                  text: logic.menuParamEntity.value.interval),
                              const Gap(10),
                              _FilterChip(
                                  onTap: () async {
                                    final result = await logic.openSelector([
                                      'USD',
                                      logic.menuParamEntity.value.baseCoin ??
                                          '',
                                    ]);
                                    if (result != null &&
                                        result.toLowerCase() !=
                                            logic.menuParamEntity.value.type
                                                ?.toLowerCase()) {
                                      logic.menuParamEntity.value.type = result;
                                      logic.loadOIData();
                                      logic.menuParamEntity.refresh();
                                    }
                                  },
                                  text: logic.menuParamEntity.value.type),
                              const Gap(15),
                            ],
                          );
                        }),
                        Container(
                          height: 400,
                          width: double.infinity,
                          margin: const EdgeInsets.all(15),
                          child: CommonWebView(
                            url: Urls.chartUrl,
                            enableZoom: Platform.isAndroid, //? true : false
                            onLoadStop: (controller) =>
                                logic.updateReadyStatus(webReady: true),
                            onWebViewCreated: (controller) {
                              logic.webCtrl = controller;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.onTap,
    required this.text,
  });

  final VoidCallback onTap;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          height: 30,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerTheme.color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Text(
                text ?? '',
                style: Styles.tsSub_12m(context),
              ),
              const Gap(10),
              const Icon(Icons.keyboard_arrow_down, size: 14)
            ],
          )),
    );
  }
}

class _CoinListView extends StatelessWidget {
  const _CoinListView({
    required this.logic,
  });

  final ExchangeOiLogic logic;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ScrollablePositionedList.builder(
          itemScrollController: logic.itemScrollController,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          itemCount: logic.coinList.length,
          itemBuilder: (context, index) {
            final item = logic.coinList[index];
            return GestureDetector(
              onTap: () {
                logic.selectedCoinIndex = index;
                logic.menuParamEntity.value.baseCoin = item;
                logic.menuParamEntity.refresh();
                logic.coinList.refresh();
                Loading.wrap(() async => logic.onRefresh());
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: index == logic.selectedCoinIndex
                          ? Styles.cMain.withOpacity(0.1)
                          : null),
                  child: Text(item,
                      style: index == logic.selectedCoinIndex
                          ? Styles.tsMain_14
                          : Styles.tsSub_14(context))),
            );
          },
          scrollDirection: Axis.horizontal);
    });
  }
}

class _OiItem extends StatelessWidget {
  const _OiItem({
    required this.item,
    required this.baseCoin,
  });

  final OIEntity item;
  final String baseCoin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/platform/${item.exchangeName?.toLowerCase()}.png',
                  width: 24,
                  height: 24,
                ),
                const Gap(10),
                Expanded(
                  child: Text(
                    item.exchangeName ?? '',
                    style: Styles.tsBody_14m(context),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${AppUtil.getLargeFormatString('${item.coinValue}')}',
                      style: Styles.tsBody_14m(context),
                    ),
                    FittedBox(
                      child: Text(
                        '≈${AppUtil.getLargeFormatString('${item.coinCount}')} $baseCoin',
                        style: Styles.tsSub_12(context),
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${((item.rate ?? 0) * 100).toStringAsFixed(2)}%',
                    textAlign: TextAlign.center,
                    style: Styles.tsBody_12(context),
                  ),
                  const Gap(6),
                  Container(
                    decoration: BoxDecoration(
                      color: Styles.cMain.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.centerLeft,
                    height: 7,
                    width: double.infinity,
                    child: FractionallySizedBox(
                      widthFactor: item.rate?.toDouble(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Styles.cMain.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 7,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                ],
              )),
          Expanded(
              flex: 6,
              child:
                  Text('${((item.change24H ?? 0) * 100).toStringAsFixed(2)}%',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: (item.change24H ?? 0) > 0
                            ? Styles.cUp(context)
                            : Styles.cDown(context),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
