import 'package:ank_app/modules/market/contract/contract_coin/contract_coin_logic.dart';
import 'package:ank_app/modules/market/contract/contract_coin/customize/reorder_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../favorite/contract_coin_logic_f.dart';

class EditCustomizePage extends StatefulWidget {
  const EditCustomizePage({super.key});

  static const routeName = '/contractCoinEditCustomize';

  @override
  State<EditCustomizePage> createState() => _EditCustomizePageState();
}

class _EditCustomizePageState extends State<EditCustomizePage> {
  final logic = Get.find<ReorderLogic>();
  var map = StoreLogic.to.contractCoinSortOrder;

  Future<void> updateMap(String key, bool value) async {
    map[key] = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final sof = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(sof.edit),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15)
                  .copyWith(bottom: 100),
              children: [
                _text(sof.s_price_chg),
                GridView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: 40,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _item(text: '1H', value: 'priceChangeH1'),
                    _item(text: '4H', value: 'priceChangeH4'),
                    _item(text: '6H', value: 'priceChangeH6'),
                    _item(text: '12H', value: 'priceChangeH12'),
                  ],
                ),
                _text(sof.s_oi_chg),
                GridView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: 40,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _item(text: '5m', value: 'openInterestChM5'),
                    _item(text: '15m', value: 'openInterestChM15'),
                    _item(text: '30m', value: 'openInterestChM30'),
                    _item(text: '1H', value: 'openInterestCh1'),
                    _item(text: '4H', value: 'openInterestCh4'),
                    _item(text: '24H', value: 'openInterestCh24'),
                    _item(text: '2D', value: 'openInterestCh2D'),
                    _item(text: '3D', value: 'openInterestCh3D'),
                    _item(text: '7D', value: 'openInterestCh7D'),
                  ],
                ),
                _text(sof.s_rekt),
                GridView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: 40,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _item(text: '1H', value: 'liquidationH1'),
                    _item(text: '4H', value: 'liquidationH4'),
                    _item(text: '12H', value: 'liquidationH12'),
                    _item(text: '24H', value: 'liquidationH24'),
                  ],
                ),
                _text(sof.s_longshort_ratio),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _item(
                        text: sof.s_buysel_longshort_ratio,
                        value: 'longShortRatio'),
                    _item(
                        text: sof.lsRatioOfAccountX('Binance or Okx'),
                        value: 'longShortPerson'),
                    _item(
                        text: sof.lsRatioOfAccountX('5m'),
                        value: 'lsPersonChg5m'),
                    _item(
                        text: sof.lsRatioOfAccountX('15m'),
                        value: 'lsPersonChg15m'),
                    _item(
                        text: sof.lsRatioOfAccountX('30m'),
                        value: 'lsPersonChg30m'),
                    _item(
                        text: sof.lsRatioOfAccountX('1H'),
                        value: 'lsPersonChg1h'),
                    _item(
                        text: sof.lsRatioOfAccountX('4H'),
                        value: 'lsPersonChg4h'),
                    _item(
                        text: 'L/S Ratio Of Top Position (Binance or Okx)',
                        value: 'longShortPosition'),
                    _item(
                        text: 'L/S Ratio Of Top Account (Binance or Okx)',
                        value: 'longShortAccount'),
                  ],
                ),
                _text(sof.marketCap),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _item(text: sof.marketCapShort, value: 'marketCap'),
                    _item(
                        text: sof.marketCapChange, value: 'marketCapChange24H'),
                    _item(
                        text: sof.circulatingSupply,
                        value: 'circulatingSupply'),
                    _item(text: sof.totalSupply, value: 'totalSupply'),
                    _item(text: sof.maxSupply, value: 'maxSupply'),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewPadding.bottom,
                top: 10,
                left: 15,
                right: 15),
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                    child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: Styles.cLine(context)),
                        onPressed: () async {
                          await StoreLogic.to.removeContractCoinSortOrder();
                          logic.initData();
                          if (Get.isRegistered<ContractCoinLogic>()) {
                            final contractCoinLogic =
                                Get.find<ContractCoinLogic>();
                            contractCoinLogic.dataSource
                                .getColumns(Get.context!);
                            contractCoinLogic.dataSource.buildDataGridRows();
                          }
                          if (Get.isRegistered<ContractCoinLogicF>()) {
                            final fLogic = Get.find<ContractCoinLogicF>();
                            fLogic.dataSource.getColumns(Get.context!);
                            fLogic.dataSource.buildDataGridRows();
                          }
                          Get.back();
                        },
                        child: Text(
                          sof.s_reset,
                          style: Styles.tsBody_16(context),
                        ))),
                const Gap(10),
                Expanded(
                  child: FilledButton(
                      onPressed: () async {
                        await StoreLogic.to.saveContractCoinSortOrder(map);
                        logic.initData();
                        if (Get.isRegistered<ContractCoinLogic>()) {
                          final contractCoinLogic =
                              Get.find<ContractCoinLogic>();
                          contractCoinLogic.dataSource.getColumns(Get.context!);
                          contractCoinLogic.dataSource.buildDataGridRows();
                        }
                        if (Get.isRegistered<ContractCoinLogicF>()) {
                          final fLogic = Get.find<ContractCoinLogicF>();
                          fLogic.dataSource.getColumns(Get.context!);
                          fLogic.dataSource.buildDataGridRows();
                        }
                        Get.back();
                      },
                      child: Text(sof.s_ok,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _text(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(text),
    );
  }

  Widget _item({required String text, required String value}) {
    final selected = map[value] ?? false;
    return GestureDetector(
      onTap: () => updateMap(value, !selected),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: selected
                    ? Styles.cMain
                    : Theme.of(context).dividerTheme.color!)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                  color: selected ? Styles.cMain : Styles.cBody(context),
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
