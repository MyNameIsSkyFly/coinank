import 'package:ank_app/entity/market_cap_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/rate_with_sign.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Set product's data collection to data grid source.
class GridDataSource extends DataGridSource {
  /// Creates the product data source class with required details.
  GridDataSource(this.items, this.baseCoin) {
    buildDataGridRows();
  }

  /// Instance of products.
  final List<MarketCapEntity> items;
  final String baseCoin;

  /// Instance of DataGridRow.
  List<DataGridRow> dataGridRows = <DataGridRow>[];

  /// Build DataGridRows
  void buildDataGridRows() {
    dataGridRows = items.mapIndexed<DataGridRow>((index, entity) {
      return DataGridRow(cells: <DataGridCell<dynamic>>[
        DataGridCell<int>(columnName: '1', value: index),
        DataGridCell<(String?, String?)>(
            columnName: '2', value: (entity.name, entity.symbol)),
        DataGridCell<double>(columnName: '3', value: entity.marketCap ?? 0),
        DataGridCell<double>(
            columnName: '4', value: entity.marketCapChangePercentage24h),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  final numberFormat = NumberFormat('#,###');

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(10).copyWith(left: 15),
          child: Text(
            (row.getCells()[0].value + 1).toString(),
            style: Styles.tsBody_14(Get.context!),
          ),
        ),
      ),
      Builder(builder: (context) {
        final item = row.getCells()[1].value as (String?, String?);
        return Row(
          children: [
            ImageUtil.coinImage((item.$2 ?? '').toUpperCase(), size: 24),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$2.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: Styles.tsBody_14m(context),
                      ),
                      Text(
                        item.$1.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: Styles.tsSub_12m(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '\$${numberFormat.format(row.getCells()[2].value)}',
            overflow: TextOverflow.ellipsis,
            style: Styles.tsBody_14m(Get.context!),
          ),
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8),
        child: RateWithSign(
          rate: row.getCells()[3].value,
          fontSize: 14,
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
