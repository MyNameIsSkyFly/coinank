import 'package:ank_app/modules/market/spot/favorite/spot_coin_logic_f.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../spot_coin/spot_coin_logic.dart';
import '../spot_logic.dart';
import 'reorder_spot_logic.dart';

class EditCustomizeSpotPage extends StatefulWidget {
  const EditCustomizeSpotPage({super.key});

  static const routeName = '/spotEditCustomize';

  @override
  State<EditCustomizeSpotPage> createState() => _EditCustomizeSpotPageState();
}

class _EditCustomizeSpotPageState extends State<EditCustomizeSpotPage> {
  final logic = Get.find<ReorderSpotLogic>();
  var map = StoreLogic.to.spotSortOrder;

  Future<void> updateMap(String key, bool value) async {
    map[key] = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var sof = S.of(context);
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
                    _item(text: '5m', value: 'priceChangeM5'),
                    _item(text: '15m', value: 'priceChangeM15'),
                    _item(text: '30m', value: 'priceChangeM30'),
                    _item(text: '1h', value: 'priceChangeH1'),
                    _item(text: '4h', value: 'priceChangeH4'),
                    _item(text: '8h', value: 'priceChangeH8'),
                    _item(text: '12h', value: 'priceChangeH12'),
                  ],
                ),
                _text(sof.otherData),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _item(text: sof.marketCapShort, value: 'marketCap'),
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
                          await StoreLogic.to.removeSpotSortOrder();
                          logic.initData();
                          if (Get.isRegistered<SpotLogic>()) {
                            var logic = Get.find<SpotCoinLogic>();
                            logic.dataSource.getColumns(Get.context!);
                            logic.dataSource.buildDataGridRows();
                          }
                          if (Get.isRegistered<FSpotCoinLogic>()) {
                            var logic = Get.find<FSpotCoinLogic>();
                            logic.dataSource.getColumns(Get.context!);
                            logic.dataSource.buildDataGridRows();
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
                        await StoreLogic.to.saveSpotSortOrder(map);
                        logic.initData();
                        if (Get.isRegistered<SpotLogic>()) {
                          var logic = Get.find<SpotCoinLogic>();
                          logic.dataSource.getColumns(Get.context!);
                          logic.dataSource.buildDataGridRows();
                        }
                        if (Get.isRegistered<FSpotCoinLogic>()) {
                          var logic = Get.find<FSpotCoinLogic>();
                          logic.dataSource.getColumns(Get.context!);
                          logic.dataSource.buildDataGridRows();
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
