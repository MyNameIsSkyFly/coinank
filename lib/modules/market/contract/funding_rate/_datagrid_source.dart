import 'package:ank_app/entity/marker_funding_rate_entity.dart';
import 'package:ank_app/modules/market/contract/funding_rate/funding_rate_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Set product's data collection to data grid source.
class GridDataSource extends DataGridSource {
  /// Creates the product data source class with required details.
  GridDataSource(this.items) {
    buildDataGridRows();
  }

  final state = Get.find<FundingRateLogic>().state;

  /// Instance of products.
  final List<MarkerFundingRateEntity> items;

  /// Instance of DataGridRow.
  List<DataGridRow> dataGridRows = <DataGridRow>[];

  /// Build DataGridRows
  void buildDataGridRows() {
    dataGridRows = items.where((element) {
      if (state.searchList.isEmpty) return true;
      return state.searchList.contains(element.symbol);
    }).mapIndexed<DataGridRow>((index, entity) {
      final dataMap = state.isCmap.value ? entity.cmap : entity.umap;
      return DataGridRow(cells: <DataGridCell<dynamic>>[
        DataGridCell<String>(columnName: '1', value: entity.symbol),
        DataGridCell<_DataClass>(
            columnName: '2',
            value: _DataClass(dataMap?[state.topList[0]]?.fundingRate,
                dataMap?[state.topList[0]]?.estimatedRate
        )),
        DataGridCell<_DataClass>(
            columnName: '3',
            value: _DataClass(dataMap?[state.topList[1]]?.fundingRate,
                dataMap?[state.topList[1]]?.estimatedRate
        )),
        DataGridCell<_DataClass>(
            columnName: '4',
            value: _DataClass(dataMap?[state.topList[2]]?.fundingRate,
                dataMap?[state.topList[2]]?.estimatedRate
        )),
        DataGridCell<_DataClass>(
            columnName: '5',
            value: _DataClass(dataMap?[state.topList[3]]?.fundingRate,
                dataMap?[state.topList[3]]?.estimatedRate
        )),
        DataGridCell<_DataClass>(
            columnName: '6',
            value: _DataClass(dataMap?[state.topList[4]]?.fundingRate,
                dataMap?[state.topList[4]]?.estimatedRate
        )),
        DataGridCell<_DataClass>(
            columnName: '7',
            value: _DataClass(dataMap?[state.topList[5]]?.fundingRate,
                dataMap?[state.topList[5]]?.estimatedRate
        )),
        DataGridCell<_DataClass>(
            columnName: '8',
            value: _DataClass(dataMap?[state.topList[6]]?.fundingRate,
                dataMap?[state.topList[6]]?.estimatedRate
        )),
      ]);
    }).toList();
    updateDataSource();
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
                    style: Styles.tsBody_14m(Get.context!),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: _rateText(row.getCells()[1].value),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: _rateText(row.getCells()[2].value),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: _rateText(row.getCells()[3].value),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: _rateText(row.getCells()[4].value),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: _rateText(row.getCells()[5].value),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: _rateText(row.getCells()[6].value),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: _rateText(row.getCells()[7].value),
      ),
    ]);
  }

  Widget _rateText(_DataClass? rate) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppUtil.getRate(rate: rate?.value1, precision: 4, showAdd: false),
          style: Styles.tsBody_12m(Get.context!).copyWith(
            fontSize: state.isHide.value ? 16 : 14,
            color: AppUtil.getColorWithFundRate(rate?.value1),
          ),
        ),
        if (!state.isHide.value)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              AppUtil.getRate(rate: rate?.value2, precision: 4, showAdd: false),
              style: Styles.tsBody_12m(Get.context!).copyWith(
                fontSize: state.isHide.value ? 16 : 14,
                color: AppUtil.getColorWithFundRate(rate?.value2),
              ),
            ),
          ),
      ],
    );
  }

  /// Update DataSource
  void updateDataSource() {
    notifyListeners();
    notifyDataSourceListeners();
  }

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    final valueA = (a
                ?.getCells()
                .firstWhereOrNull(
                    (element) => element.columnName == sortColumn.name)
                ?.value as _DataClass?)
            ?.value1 ??
        (sortColumn.sortDirection == DataGridSortDirection.ascending
            ? 10
            : -10);
    final valueB = (b
                ?.getCells()
                .firstWhereOrNull(
                    (element) => element.columnName == sortColumn.name)
                ?.value as _DataClass?)
            ?.value1 ??
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

class _DataClass {
  final double? value1;
  final double? value2;

  _DataClass(this.value1, this.value2);

  @override
  String toString() {
    return '${value1?.toStringAsFixed(4)}%';
  }
}
