// ignore: depend_on_referenced_packages
import 'package:ank_app/entity/contract_market_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/rate_with_sign.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Set product's data collection to data grid source.
class GridDataSource extends DataGridSource {
  /// Creates the product data source class with required details.
  GridDataSource(this.items, this.baseCoin) {
    buildDataGridRows();
  }

  /// Instance of products.
  final List<ContractMarketEntity> items;
  final String baseCoin;

  /// Instance of DataGridRow.
  List<DataGridRow> dataGridRows = <DataGridRow>[];

  /// Build DataGridRows
  void buildDataGridRows() {
    dataGridRows = items.map<DataGridRow>((ContractMarketEntity entity) {
      return DataGridRow(cells: <DataGridCell<dynamic>>[
        //todo intl
        DataGridCell<String>(columnName: '1', value: entity.exchangeName),
        DataGridCell<(String?, String?, String?)>(
            columnName: '2',
            value: (entity.symbol, entity.exchangeName, entity.contractType)),
        DataGridCell<double>(columnName: '3', value: entity.lastPrice),
        DataGridCell<double>(columnName: '4', value: entity.priceChange24h),
        DataGridCell<double>(columnName: '5', value: entity.turnover24h),
        DataGridCell<double>(columnName: '6', value: entity.oiUSD),
        DataGridCell<double>(columnName: '7', value: entity.oiChg24h),
        DataGridCell<double>(columnName: '8', value: entity.fundingRate),
      ]);
    }).toList();
  }

  final clickableExchangeNames = [
    'BINANCE',
    'HUOBI',
    'OKX',
    'BYBIT',
    'GATE',
    'BITGET'
  ];

  bool isClickable(String? name) {
    return clickableExchangeNames.contains((name ?? '').toUpperCase());
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8).copyWith(left: 15),
        child: Row(
          children: [
            ImageUtil.exchangeImage(row.getCells()[0].value.toString(),
                size: 24),
            const Gap(10),
            Expanded(
              child: Text(
                row.getCells()[0].value.toString(),
                overflow: TextOverflow.ellipsis,
                style: Styles.tsBody_14m(Get.context!),
              ),
            ),
          ],
        ),
      ),
      Builder(builder: (context) {
        final item = row.getCells()[1].value as (String?, String?, String?);
        var clickable = isClickable(item.$2);
        return GestureDetector(
          onTap: () {
            if (!clickable) return;
            AppUtil.toKLine(
                item.$2 ?? '', item.$1 ?? '', baseCoin, item.$3 ?? '');
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.$1.toString(),
                overflow: TextOverflow.ellipsis,
                style:
                    clickable ? Styles.tsMain_14m : Styles.tsBody_14m(context),
              ),
            ),
          ),
        );
      }),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
          style: Styles.tsBody_14m(Get.context!),
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: RateWithSign(rate: row.getCells()[3].value ?? 0, fontSize: 14),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: Text(
          AppUtil.getLargeFormatString('${row.getCells()[4].value ?? 0}',
              precision: 2),
          overflow: TextOverflow.ellipsis,
          style: Styles.tsBody_14m(Get.context!),
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: Text(
          AppUtil.getLargeFormatString('${row.getCells()[5].value ?? 0}',
              precision: 2),
          overflow: TextOverflow.ellipsis,
          style: Styles.tsBody_14m(Get.context!),
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: RateWithSign(rate: row.getCells()[6].value ?? 0, fontSize: 14),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: Text(
          '${((row.getCells()[7].value ?? 0) * 100).toStringAsFixed(4)}%',
          overflow: TextOverflow.ellipsis,
          style: Styles.tsBody_14m(Get.context!),
        ),
      ),
    ]);
  }

  /// Update DataSource
  void updateDataSource() {
    notifyListeners();
  }

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    if (sortColumn.name == '1') {
      final String? valueA = a
          ?.getCells()
          .firstWhereOrNull(
              (dynamic element) => element.columnName == sortColumn.name)
          ?.value
          ?.toString();
      final String? valueB = b
          ?.getCells()
          .firstWhereOrNull(
              (dynamic element) => element.columnName == sortColumn.name)
          ?.value
          ?.toString();
      if (valueA == null || valueB == null) {
        return 0;
      }

      if (sortColumn.sortDirection == DataGridSortDirection.ascending) {
        return valueA.toLowerCase().compareTo(valueB.toLowerCase());
      } else {
        return valueB.toLowerCase().compareTo(valueA.toLowerCase());
      }
    } else {
      final double? valueA = a
          ?.getCells()
          .firstWhereOrNull(
              (dynamic element) => element.columnName == sortColumn.name)
          ?.value;
      final double? valueB = b
          ?.getCells()
          .firstWhereOrNull(
              (dynamic element) => element.columnName == sortColumn.name)
          ?.value;
      if (valueA == null || valueB == null) {
        return 0;
      }

      if (sortColumn.sortDirection == DataGridSortDirection.ascending) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    }
  }
}
