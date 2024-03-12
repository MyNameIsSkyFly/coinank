import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'contract_coin_key_value.dart';
import 'contract_coin_logic.dart';
import 'contract_coin_state.dart';

/// Set product's data collection to data grid source.
class GridDataSource extends DataGridSource {
  /// Creates the product data source class with required details.
  GridDataSource(this.items) {
    buildDataGridRows();
  }

  final logic = Get.find<ContractCoinLogic>();
  late final ContractCoinState state = logic.state;

  /// Instance of products.
  final List<MarkerTickerEntity> items;

  /// Instance of DataGridRow.
  List<DataGridRow> dataGridRows = <DataGridRow>[];
  late BuildContext context;

  /// Build DataGridRows
  void buildDataGridRows() {
    dataGridRows = items.mapIndexed<DataGridRow>((index, entity) {
      return DataGridRow(cells: <DataGridCell<dynamic>>[
        DataGridCell(columnName: '0', value: entity.baseCoin),
        ...StoreLogic.to.contractCoinSortOrder.entries
            .where((element) => element.value == true)
            .mapIndexed((index, e) {
          return DataGridCell(
              columnName: logic.textMap(e.key),
              value: ContractCoinKeyValue(e.key, entity.toJson()[e.key],
                  numberFormat: _numberFormat, baseCoin: entity.baseCoin));
        })
      ]);
    }).toList();
    updateDataSource();
  }

  final _numberFormat = NumberFormat('#,###');

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
            ClipOval(
                child: ImageUtil.coinImage(row.getCells()[0].value.toString(),
                    size: 24)),
            const Gap(10),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    row.getCells()[0].value.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: Styles.tsBody_14m(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ...StoreLogic.to.contractCoinSortOrder.entries
          .where((element) => element.value == true)
          .mapIndexed(
            (index, e) => Container(
              padding: const EdgeInsets.all(8),
              child: (row.getCells()[index + 1].value as ContractCoinKeyValue)
                  .rateText,
            ),
          )
    ]);
  }


  /// Update DataSource
  void updateDataSource() {
    notifyListeners();
    notifyDataSourceListeners();
  }

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    final double valueA = a
            ?.getCells()
            .firstWhereOrNull(
                (dynamic element) => element.columnName == sortColumn.name)
            ?.value
            ?.value ??
        (sortColumn.sortDirection == DataGridSortDirection.ascending
            ? 10
            : -10);
    final double valueB = b
            ?.getCells()
            .firstWhereOrNull(
                (dynamic element) => element.columnName == sortColumn.name)
            ?.value
            ?.value ??
        (sortColumn.sortDirection == DataGridSortDirection.ascending
            ? 10
            : -10);

    if (sortColumn.sortDirection == DataGridSortDirection.ascending) {
      return valueA.compareTo(valueB);
    } else {
      return valueB.compareTo(valueA);
    }
  }
}
