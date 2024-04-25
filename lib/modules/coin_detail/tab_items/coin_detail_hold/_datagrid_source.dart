import 'package:ank_app/entity/hold_address_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Set product's data collection to data grid source.
class GridDataSource extends DataGridSource {
  /// Creates the product data source class with required details.
  GridDataSource(this.items, {this.showChange = true}) {
    buildDataGridRows();
  }

  /// Instance of products.
  final List<HoldAddressItemEntity> items;
  final bool showChange;

  /// Instance of DataGridRow.
  List<DataGridRow> dataGridRows = <DataGridRow>[];

  /// Build DataGridRows
  void buildDataGridRows() {
    dataGridRows = items.mapIndexed<DataGridRow>((index, entity) {
      return DataGridRow(cells: <DataGridCell<dynamic>>[
        DataGridCell<int>(columnName: '1', value: index),
        DataGridCell<String>(columnName: '2', value: entity.quantity),
        DataGridCell<String>(columnName: '3', value: '${entity.percentage}%'),
        DataGridCell<String>(columnName: '4', value: entity.changePercent),
        DataGridCell<_ValueKey>(
            columnName: '5',
            value: _ValueKey(
                address: entity.address,
                platform: entity.platform,
                shortAddress: shortenString(entity.address ?? ''))),
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
          padding: const EdgeInsets.all(10),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              ((row.getCells()[0].value as int) + 1).toString(),
              style: Styles.tsBody_14m(Get.context!),
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              AppUtil.getLargeFormatString(row.getCells()[1].value),
              style: Styles.tsBody_14m(Get.context!),
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            row.getCells()[2].value.toString(),
            style: Styles.tsBody_14m(Get.context!),
          ),
        ),
      ),
      if (showChange)
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                row.getCells()[3].value.toString(),
                style: TextStyle(
                  fontWeight: Styles.fontMedium,
                  color: (double.tryParse(row.getCells()[3].value.toString()) ??
                              0) >=
                          0
                      ? Styles.cUp(Get.context!)
                      : Styles.cDown(Get.context!),
                ),
              ),
            ),
          ),
        ),
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FittedBox(
            child: GestureDetector(
              onTap: () => AppUtil.copy(row.getCells()[4].value.address ?? ''),
              child: Row(
                children: [
                  Text(
                    row.getCells()[4].value.shortAddress ?? '',
                    style: Styles.tsBody_14m(Get.context!),
                  ),
                  if ((row.getCells()[4].value.platform as String?)
                          ?.isNotEmpty ==
                      true) ...[
                    const Gap(5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Styles.cSub(Get.context!).withOpacity(0.2),
                      ),
                      child: Text(
                        row.getCells()[4].value.platform ?? '',
                        style: Styles.tsBody_12(Get.context!),
                      ),
                    )
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  String shortenString(String input,
      {int prefixLength = 4, int suffixLength = 4}) {
    if (input.length <= prefixLength + suffixLength) {
      return input;
    } else {
      String prefix = input.substring(0, prefixLength);
      String suffix = input.substring(input.length - suffixLength);
      return '$prefix...$suffix';
    }
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
          .firstWhereOrNull((element) => element.columnName == sortColumn.name)
          ?.value
          ?.toString();
      final String? valueB = b
          ?.getCells()
          .firstWhereOrNull((element) => element.columnName == sortColumn.name)
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
          .firstWhereOrNull((element) => element.columnName == sortColumn.name)
          ?.value;
      final double? valueB = b
          ?.getCells()
          .firstWhereOrNull((element) => element.columnName == sortColumn.name)
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

class _ValueKey {
  String? address;
  String? shortAddress;
  String? platform;

  _ValueKey({this.address, this.shortAddress, this.platform});

  @override
  String toString() => '$shortAddress $platform';
}
