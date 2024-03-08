import 'package:ank_app/res/export.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'customize/reorder_spot_view.dart';

mixin SpotLogicMixin {
  var sortOrderMap = <MapEntry<String, bool>>[];
  final columns = RxList<GridColumn>();
  final columnsF = RxList<GridColumn>();

  void getColumns(BuildContext context) {
    sortOrderMap = StoreLogic.to.spotSortOrder.entries
        .where((element) => element.value == true)
        .toList();
    List<GridColumn> grids() => [
          GridColumn(
            columnName: '0',
            width: 100,
            allowSorting: false,
            label: Builder(builder: (context) {
              return InkWell(
                onTap: () => Get.toNamed(ReorderSpotPage.routeName),
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
                        S.of(context).customizeList,
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
    columns.assignAll(grids());
    columnsF.assignAll(grids());
  }

  GridColumn _gridColumn(BuildContext context, int index, String text) {
    return GridColumn(
        columnName: text,
        maximumWidth: 140,
        autoFitPadding: EdgeInsets.zero,
        label: Builder(builder: (context) {
          return Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Styles.tsSub_12m(context),
            ),
          );
        }));
  }

  String textMap(String key) {
    return switch (key) {
      'price' => S.current.s_price,
      'turnover24h' => '${S.current.s_24h_turnover}(\$)',
      'turnoverChg24h' => '${S.current.s_24h_turnover}(%)',
      'priceChangeM5' => '${S.current.s_price}(5m%)',
      'priceChangeM15' => '${S.current.s_price}(15m%)',
      'priceChangeM30' => '${S.current.s_price}(30m%)',
      'priceChangeH1' => '${S.current.s_price}(1H%)',
      'priceChangeH4' => '${S.current.s_price}(4H%)',
      'priceChangeH8' => '${S.current.s_price}(8H%)',
      'priceChangeH12' => '${S.current.s_price}(12H%)',
      'priceChangeH24' => '${S.current.s_price}(24H%)',
      'marketCap' => S.current.marketCap,
      'marketCapChange24H' => S.current.marketCapChange,
      'circulatingSupply' => S.current.circulatingSupply,
      'totalSupply' => S.current.totalSupply,
      'maxSupply' => S.current.maxSupply,
      _ => '',
    };
  }
}
