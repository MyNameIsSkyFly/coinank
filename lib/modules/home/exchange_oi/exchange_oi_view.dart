import 'package:ank_app/entity/oi_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/common_webview.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'exchange_oi_logic.dart';

class ExchangeOiPage extends StatefulWidget {
  const ExchangeOiPage({super.key});

  static const String routeName = '/exchange_oi';

  @override
  State<ExchangeOiPage> createState() => _ExchangeOiPageState();
}

class _ExchangeOiPageState extends State<ExchangeOiPage> {
  final logic = Get.put(ExchangeOiLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitleBar(
        title: S.of(context).s_open_interest,
      ),
      body: Column(
        children: [
          Obx(() {
            return SizedBox(
              width: double.infinity,
              height: 30,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: logic.coinList.length,
                  itemBuilder: (context, index) {
                    final item = logic.coinList[index];
                    return GestureDetector(
                      onTap: () {
                        var last = logic.coinList.indexWhere((element) =>
                            element.$1 == logic.menuParamEntity.value.baseCoin);
                        logic.coinList[last] = (logic.coinList[last].$1, false);
                        logic.menuParamEntity.update((val) {
                          val?.baseCoin = item.$1;
                        });
                        logic.coinList[index] = (item.$1, true);
                        logic.coinList.refresh();
                        Loading.wrap(() async => Future.wait(
                            [logic.loadData(), logic.loadOIData()]));
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: item.$2
                                  ? Theme.of(context).dividerTheme.color
                                  : null),
                          child: Text(item.$1)),
                    );
                  },
                  scrollDirection: Axis.horizontal),
            );
          }),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Obx(() {
                    return Column(
                      children: logic.oiList.mapIndexed(
                        (index, element) {
                          final item = logic.oiList[index];
                          return _OiItem(
                            item: item,
                            baseCoin:
                                logic.menuParamEntity.value.baseCoin ?? '',
                          );
                        },
                      ).toList(),
                    );
                  }),
                  Container(
                    height: 400,
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    child: CommonWebView(
                      url: 'assets/files/t18.html',
                      isFile: true,
                      onWebViewCreated: (controller) {
                        logic.webCtrl = controller;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/platform/${item.exchangeName?.toLowerCase()}.png',
                  width: 20,
                  height: 20,
                ),
                Text(item.exchangeName ?? ''),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '\$${AppUtil.getLargeFormatString('${item.coinValue}')}'),
                  Text(
                      '≈${AppUtil.getLargeFormatString('${item.coinCount}')} $baseCoin'),
                ],
              )),
          Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    width: double.infinity,
                    color: Theme.of(context).dividerTheme.color,
                    child: FractionallySizedBox(
                      widthFactor: item.rate?.toDouble(),
                      child: Container(
                        height: 30,
                        alignment: Alignment.centerLeft,
                        color: Styles.cMain.withOpacity(0.3),
                      ),
                    ),
                  ),
                  Positioned(
                      left: 5,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Text(
                          '${((item.rate ?? 0) * 100).toStringAsFixed(2)}%',
                          textAlign: TextAlign.center,
                        ),
                      ))
                ],
              )),
          Expanded(
              flex: 1,
              child:
                  Text('${((item.change24H ?? 0) * 100).toStringAsFixed(2)}%',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: (item.change24H ?? 0) > 0
                            ? Styles.cUp(context)
                            : Styles.cDown(context),
                      ))),
        ],
      ),
    );
  }
}
