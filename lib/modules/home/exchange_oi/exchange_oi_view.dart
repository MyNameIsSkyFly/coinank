import 'dart:io';

import 'package:ank_app/modules/coin_detail/coin_detail_logic.dart';
import 'package:ank_app/modules/market/contract/contract_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/app_refresh.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../constants/urls.dart';
import 'exchange_oi_logic.dart';

class ExchangeOiPage extends StatelessWidget {
  const ExchangeOiPage({super.key, this.inCoinDetail = false});

  final bool inCoinDetail;

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(
        ExchangeOiLogic(
            inCoinDetail: inCoinDetail,
            baseCoin: inCoinDetail
                ? Get.find<CoinDetailLogic>().coin.baseCoin
                : Get.find<ContractLogic>().state.exchangeOIBaseCoin),
        tag: inCoinDetail ? 'coinDetail' : null);
    return Scaffold(
      body: Obx(() {
        if (logic.loading.value) {
          return const LottieIndicator();
        } else {
          return Column(
            children: [
              if (!inCoinDetail)
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
                child: AppRefresh(
                  onRefresh: () async => logic.onRefresh(),
                  child: ListView(
                    padding: EdgeInsets.only(top: inCoinDetail ? 10 : 0),
                    children: [
                      SfDataGridTheme(
                        data: const SfDataGridThemeData(
                          frozenPaneLineColor: Colors.transparent,
                        ),
                        child: SfDataGrid(
                          source: logic.gridSource,
                          shrinkWrapRows: true,
                          headerGridLinesVisibility: GridLinesVisibility.none,
                          gridLinesVisibility: GridLinesVisibility.none,
                          headerRowHeight: 15,
                          frozenColumnsCount: 1,
                          verticalScrollPhysics:
                              const NeverScrollableScrollPhysics(),
                          horizontalScrollPhysics:
                              const ClampingScrollPhysics(),
                          columns: [
                            GridColumn(
                              columnName: 'exchange',
                              width: MediaQuery.of(context).size.width * 0.29,
                              label: Container(
                                padding: const EdgeInsets.only(left: 15),
                                alignment: Alignment.centerLeft,
                                child: Text(S.of(context).s_exchange_name,
                                    style: Styles.tsSub_12(context)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'oi',
                              width: MediaQuery.of(context).size.width * 0.26,
                              label: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(S.of(context).s_oi,
                                    style: Styles.tsSub_12(context)),
                              ),
                            ),
                            GridColumn(
                                columnName: 'rate',
                                width: MediaQuery.of(context).size.width * 0.26,
                                label: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(S.of(context).s_rate,
                                      style: Styles.tsSub_12(context)),
                                )),
                            GridColumn(
                                width: MediaQuery.of(context).size.width * 0.17,
                                columnName: 'change1H',
                                label: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      S
                                          .of(context)
                                          .s_4h_chg
                                          .replaceFirst('4', '1'),
                                      style: Styles.tsSub_12(context)),
                                )),
                            GridColumn(
                                columnName: 'change4H',
                                width: MediaQuery.of(context).size.width * 0.17,
                                label: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(S.of(context).s_4h_chg,
                                      style: Styles.tsSub_12(context)),
                                )),
                            GridColumn(
                                columnName: 'change24H',
                                width: MediaQuery.of(context).size.width * 0.17,
                                label: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(S.of(context).s_24h_chg,
                                      style: Styles.tsSub_12(context)),
                                )),
                          ],
                        ),
                      ),
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
                                    logic.menuParamEntity.value.baseCoin ?? '',
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
                      AliveWidget(
                        child: Container(
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
                      ),
                    ],
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
                logic.gridSource.baseCoin = item;
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
