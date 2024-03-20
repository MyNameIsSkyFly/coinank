import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../utils/text_maps.dart';
import 'contract_coin_key_value.dart';

/// Set product's data collection to data grid source.
class GridDataSource extends DataGridSource {
  /// Creates the product data source class with required details.
  GridDataSource(this.items) {
    buildDataGridRows();
  }

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
              columnName: MarketMaps.contractTextMap(e.key),
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
    final double valueA = (a
                ?.getCells()
                .firstWhereOrNull(
                    (element) => element.columnName == sortColumn.name)
                ?.value as ContractCoinKeyValue?)
            ?.value ??
        (sortColumn.sortDirection == DataGridSortDirection.ascending
            ? 10
            : -10);
    final double valueB = (b
                ?.getCells()
                .firstWhereOrNull(
                    (element) => element.columnName == sortColumn.name)
                ?.value as ContractCoinKeyValue?)
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

  var sortOrderMap = <MapEntry<String, bool>>[];
  final columns = RxList<GridColumn>();

  void getColumns(BuildContext context) {
    sortOrderMap = StoreLogic.to.contractCoinSortOrder.entries
        .where((element) => element.value == true)
        .toList();
    List<GridColumn> gridColumns() => [
          GridColumn(
            columnName: '0',
            width: 110,
            allowSorting: false,
            label: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  S.of(context).coinType,
                  style: Styles.tsSub_12m(context),
                ),
              ),
            ),
          ),
          ...sortOrderMap.mapIndexed((index, e) =>
              _gridColumn(context, index, MarketMaps.contractTextMap(e.key))),
        ];
    columns.assignAll(gridColumns());
  }

  GridColumn _gridColumn(BuildContext context, int index, String text) {
    return GridColumn(
        columnName: text,
        maximumWidth: 140,
        autoFitPadding: const EdgeInsets.symmetric(horizontal: 10),
        label: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              text,
              style: Styles.tsSub_12m(context),
            ),
          );
        }));
  }
}
