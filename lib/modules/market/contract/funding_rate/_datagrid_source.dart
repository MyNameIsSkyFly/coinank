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
      var dataMap = state.isCmap.value ? entity.cmap : entity.umap;
      return DataGridRow(cells: <DataGridCell<dynamic>>[
        DataGridCell<String>(columnName: '1', value: entity.symbol),
        DataGridCell<(double?, double?)>(columnName: '2', value: (
          dataMap?[state.topList[0]]?.fundingRate,
          dataMap?[state.topList[0]]?.estimatedRate
        )),
        DataGridCell<(double?, double?)>(columnName: '3', value: (
          dataMap?[state.topList[1]]?.fundingRate,
          dataMap?[state.topList[1]]?.estimatedRate
        )),
        DataGridCell<(double?, double?)>(columnName: '4', value: (
          dataMap?[state.topList[2]]?.fundingRate,
          dataMap?[state.topList[2]]?.estimatedRate
        )),
        DataGridCell<(double?, double?)>(columnName: '5', value: (
          dataMap?[state.topList[3]]?.fundingRate,
          dataMap?[state.topList[3]]?.estimatedRate
        )),
        DataGridCell<(double?, double?)>(columnName: '6', value: (
          dataMap?[state.topList[4]]?.fundingRate,
          dataMap?[state.topList[4]]?.estimatedRate
        )),
        DataGridCell<(double?, double?)>(columnName: '7', value: (
          dataMap?[state.topList[5]]?.fundingRate,
          dataMap?[state.topList[5]]?.estimatedRate
        )),
        DataGridCell<(double?, double?)>(columnName: '8', value: (
          dataMap?[state.topList[6]]?.fundingRate,
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
      InkWell(
        onTap: () {
          AppNav.openWebUrl(
            url:
                '${StoreLogic.to.h5Prefix}/fundingRate/hist?coin=${row.getCells()[0].value}',
            dynamicTitle: true,
            title: row.getCells()[0].value.toString(),
          );
        },
        child: Container(
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
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: _rateText((row.getCells()[1].value)),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: _rateText((row.getCells()[2].value)),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: _rateText((row.getCells()[3].value)),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: _rateText((row.getCells()[4].value)),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: _rateText((row.getCells()[5].value)),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: _rateText((row.getCells()[6].value)),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: _rateText((row.getCells()[7].value)),
      ),
    ]);
  }

  Widget _rateText((double?, double?)? rate) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppUtil.getRate(rate: rate?.$1, precision: 4, showAdd: false),
          style: Styles.tsBody_12m(Get.context!).copyWith(
            fontSize: state.isHide.value ? 16 : 14,
            color: AppUtil.getColorWithFundRate(rate?.$1),
          ),
        ),
        if (!state.isHide.value)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              AppUtil.getRate(rate: rate?.$2, precision: 4, showAdd: false),
              style: Styles.tsBody_12m(Get.context!).copyWith(
                fontSize: state.isHide.value ? 16 : 14,
                color: AppUtil.getColorWithFundRate(rate?.$2),
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
    final double valueA = a
            ?.getCells()
            .firstWhereOrNull(
                (dynamic element) => element.columnName == sortColumn.name)
            ?.value
            ?.$1 ??
        (sortColumn.sortDirection == DataGridSortDirection.ascending
            ? 10
            : -10);
    final double valueB = b
            ?.getCells()
            .firstWhereOrNull(
                (dynamic element) => element.columnName == sortColumn.name)
            ?.value
            ?.$1 ??
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
