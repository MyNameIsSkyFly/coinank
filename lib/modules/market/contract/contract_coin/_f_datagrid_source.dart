import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/animated_color_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'contract_coin_logic.dart';
import 'contract_coin_state.dart';

/// Set product's data collection to data grid source.
class FGridDataSource extends DataGridSource {
  /// Creates the product data source class with required details.
  FGridDataSource(this.items) {
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
              value: _KeyValue(e.key, entity.toJson()[e.key],
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
              child: _rateText((row.getCells()[index + 1].value)),
            ),
          )
    ]);
  }

  Widget _rateText(_KeyValue data) {
    if (data.key == 'price') {
      return Center(
        child: AnimatedColorText(
          text: data.convertedValue,
          value: data.value ?? 0,
          style: TextStyle(fontSize: 16, fontWeight: Styles.fontMedium),
          recyclable: true,
        ),
      );
    }
    if (data.isRate) {
      return Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: data.value == null || data.value == 0
                ? Styles.cUp(context)
                : data.value! > 0
                    ? Styles.cUp(context)
                    : Styles.cDown(context),
          ),
          child: Text(
            data.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      );
    }
    return Center(
      child: AutoSizeText(
        data.convertedValue,
        maxLines: 1,
        style: Styles.tsBody_16m(context),
      ),
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

class _KeyValue {
  final String key;
  final double? value;
  final NumberFormat? numberFormat;
  final String? baseCoin;

  _KeyValue(this.key, this.value, {this.numberFormat, this.baseCoin});

  String get convertedValue => handleValue(key, value);

  bool get isRate {
    var tmp = convertedValue;
    return ['+', '-'].any((element) =>
        (tmp.startsWith(element)) && tmp.endsWith('%') ||
        tmp == '0.00%' ||
        tmp == '0.0000%');
  }

  String handleValue(String key, double? value) {
    if (value == null && key == 'marketCapChange24H') return '0.00%';
    final tmp = value ?? 0;
    return switch (key) {
      'price' => AppUtil.compressNumberWithLotsOfZeros(value ?? 0),
      'longShortRatio' ||
      'longShortPerson' ||
      'longShortPosition' ||
      'longShortAccount' =>
        Decimal.tryParse('$tmp').toString(),
      'fundingRate' =>
        '${tmp > 0 ? '+' : ''}${(tmp * 100).toStringAsFixed(4)}%',
      'turnover24h' ||
      'openInterest' ||
      'marketCap' ||
      'liquidationH1' ||
      'liquidationH4' ||
      'liquidationH12' ||
      'liquidationH24' =>
        '\$${AppUtil.getLargeFormatString('$tmp', precision: 2)}',
      'priceChangeH1' ||
      'priceChangeH4' ||
      'priceChangeH6' ||
      'priceChangeH12' ||
      'priceChangeH24' =>
        '${tmp > 0 ? '+' : ''}${tmp.toStringAsFixed(2)}%',
      'openInterestChM5' ||
      'openInterestChM15' ||
      'openInterestChM30' ||
      'openInterestCh1' ||
      'openInterestCh4' ||
      'openInterestCh24' ||
      'openInterestCh2D' ||
      'openInterestCh3D' ||
      'openInterestCh7D' ||
      'lsPersonChg5m' ||
      'lsPersonChg15m' ||
      'lsPersonChg30m' ||
      'lsPersonChg1h' ||
      'lsPersonChg4h' ||
      'marketCapChange24H' =>
        '${tmp > 0 ? '+' : ''}${(tmp * 100).toStringAsFixed(2)}%',
      'circulatingSupply' ||
      'totalSupply' ||
      'maxSupply' =>
        numberFormat?.format(tmp) ?? '',
      _ => '0',
    };
  }

  @override
  String toString() {
    return '  ${handleValue(key ?? ' ', value)}  ';
  }
}
