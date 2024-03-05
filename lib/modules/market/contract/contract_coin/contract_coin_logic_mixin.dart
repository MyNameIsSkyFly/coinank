import 'package:ank_app/res/export.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'customize/reorder_view.dart';

mixin ContractCoinLogicMixin {
  var sortOrderMap = <MapEntry<String, bool>>[];
  final columns = RxList<GridColumn>();
  final fColumns = RxList<GridColumn>();

  void getColumns(BuildContext context) {
    sortOrderMap = StoreLogic.to.contractCoinSortOrder.entries
        .where((element) => element.value == true)
        .toList();
    var gridColumns = [
      GridColumn(
        columnName: '0',
        width: 100,
        allowSorting: false,
        label: Builder(builder: (context) {
          return InkWell(
            onTap: () => Get.toNamed(ReorderPage.routeName),
            child: Row(
              children: [
                const Gap(15),
                Image.asset(
                  Assets.commonIcPuzzlePiece,
                  width: 12,
                  height: 12,
                  color: Styles.cBody(context),
                ),
                const Gap(4),
                Expanded(
                  child: Text(
                    S.of(context).customList,
                    style: Styles.tsBody_12m(context),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      ...sortOrderMap.mapIndexed(
          (index, e) => _gridColumn(context, index, textMap(e.key))),
    ];
    columns.assignAll(gridColumns);
    fColumns.assignAll(gridColumns);
  }

  GridColumn _gridColumn(BuildContext context, int index, String text) {
    return GridColumn(
        columnName: text,
        // maximumWidth: text == S.current.s_price ? 150 : double.nan,
        maximumWidth: 100,
        autoFitPadding: const EdgeInsets.only(right: 30),
        filterIconPadding: EdgeInsets.zero,
        label: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              text,
              style: Styles.tsSub_12m(context),
            ),
          );
        }));
  }

  String textMap(String key) => switch (key) {
        'price' => S.current.s_price,
        'fundingRate' => S.current.s_funding_rate,
        'turnover24h' => S.current.s_24h_turnover,
        'openInterest' => S.current.s_oi,
        'priceChangeH1' => '${S.current.s_price}(1H%)',
        'priceChangeH4' => '${S.current.s_price}(4H%)',
        'priceChangeH6' => '${S.current.s_price}(6H%)',
        'priceChangeH12' => '${S.current.s_price}(12H%)',
        'priceChangeH24' => '${S.current.s_price}(24H%)',
        'openInterestChM5' => '${S.current.s_oi}(5m%)',
        'openInterestChM15' => '${S.current.s_oi}(15m%)',
        'openInterestChM30' => '${S.current.s_oi}(30m%)',
        'openInterestCh1' => '${S.current.s_oi}(1H%)',
        'openInterestCh4' => '${S.current.s_oi}(4H%)',
        'openInterestCh24' => '${S.current.s_oi}(24H%)',
        'openInterestCh2D' => '${S.current.s_oi}(2D%)',
        'openInterestCh3D' => '${S.current.s_oi}(3D%)',
        'openInterestCh7D' => '${S.current.s_oi}(7D%)',
        'liquidationH1' => '1H ${S.current.liq_abbr}(\$)',
        'liquidationH4' => '4H ${S.current.liq_abbr}(\$)',
        'liquidationH12' => '12H ${S.current.liq_abbr}(\$)',
        'liquidationH24' => '24H ${S.current.liq_abbr}(\$)',
        'longShortRatio' => '${S.current.s_buysel_longshort_ratio}(\$)',
        'longShortPerson' => '${S.current.s_longshort_person}(\$)',
        'lsPersonChg5m' => '${S.current.longShortPersonRatio('5m')}(\$)',
        'lsPersonChg15m' => '${S.current.longShortPersonRatio('15m')}(\$)',
        'lsPersonChg30m' => '${S.current.longShortPersonRatio('30m')}(\$)',
        'lsPersonChg1h' => '${S.current.longShortPersonRatio('1H')}(\$)',
        'lsPersonChg4h' => '${S.current.longShortPersonRatio('4H')}(\$)',
        'longShortPosition' => '${S.current.s_top_trader_position_ratio}(\$)',
        'longShortAccount' => '${S.current.s_top_trader_accounts_ratio}(\$)',
        'marketCap' => S.current.marketCap,
        'marketCapChange24H' => S.current.marketCapChange,
        'circulatingSupply' => S.current.circulatingSupply,
        'totalSupply' => S.current.totalSupply,
        'maxSupply' => S.current.maxSupply,
        _ => '',
      };
}
