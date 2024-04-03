import 'package:ank_app/entity/futures_big_data_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/data_grid_widgets.dart';
import 'package:collection/collection.dart';
import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'price_change_logic.dart';

class PriceChgGridSource extends DataGridSource {
  final List<MarkerTickerEntity> list;

  PriceChgGridSource({required this.list});

  final logic = Get.find<PriceChangeLogic>();

  List<DataGridRow> dataGridRows = <DataGridRow>[];

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRows() {
    dataGridRows = list.mapIndexed<DataGridRow>((index, entity) {
      late List<DataGridCell> cells;
      if (logic.state.isPrice) {
        cells = [
          DataGridCell(columnName: 'Coin', value: entity.baseCoin),
          DataGridCell(
              columnName: logic.state.topList[0],
              value: _StringConverter(
                entity.price,
                (original) => AppUtil.compressNumberWithLotsOfZeros(original),
              )),
          DataGridCell(
              columnName: logic.state.topList[1],
              value: _StringConverter(
                entity.priceChangeH24,
                (original) =>
                    '${original > 0 ? '+' : ''}${original.toStringAsFixed(2)}%',
              )),
          DataGridCell(
              columnName: logic.state.topList[2],
              value: _StringConverter(
                entity.priceChangeM5,
                (original) =>
                    '${original > 0 ? '+' : ''}${original.toStringAsFixed(2)}%',
              )),
          DataGridCell(
              columnName: logic.state.topList[3],
              value: _StringConverter(
                entity.priceChangeM15,
                (original) =>
                    '${original > 0 ? '+' : ''}${original.toStringAsFixed(2)}%',
              )),
          DataGridCell(
              columnName: logic.state.topList[4],
              value: _StringConverter(
                entity.priceChangeM30,
                (original) =>
                    '${original > 0 ? '+' : ''}${original.toStringAsFixed(2)}%',
              )),
          DataGridCell(
              columnName: logic.state.topList[5],
              value: _StringConverter(
                entity.priceChangeH1,
                (original) =>
                    '${original > 0 ? '+' : ''}${original.toStringAsFixed(2)}%',
              )),
          DataGridCell(
              columnName: logic.state.topList[6],
              value: _StringConverter(
                entity.priceChangeH4,
                (original) =>
                    '${original > 0 ? '+' : ''}${original.toStringAsFixed(2)}%',
              )),
        ];
      } else {
        cells = [
          DataGridCell(columnName: 'Coin', value: entity.baseCoin),
          DataGridCell(
              columnName: logic.state.topList[0],
              value: _StringConverter(
                entity.price,
                (original) => AppUtil.compressNumberWithLotsOfZeros(original),
              )),
          DataGridCell(
              columnName: logic.state.topList[1],
              value: _StringConverter(
                entity.openInterestCh24?.let((it) => it * 100),
                (original) =>
                    '${original > 0 ? '+' : ''}${original.toStringAsFixed(2)}%',
              )),
          DataGridCell(
              columnName: logic.state.topList[2],
              value: _StringConverter(
                entity.openInterest,
                (original) => AppUtil.getLargeFormatString(original.toString()),
              )),
          DataGridCell(
              columnName: logic.state.topList[3],
              value: _StringConverter(
                entity.openInterestChM5?.let((it) => it * 100),
                (original) =>
                    '${original > 0 ? '+' : ''}${original.toStringAsFixed(2)}%',
              )),
          DataGridCell(
              columnName: logic.state.topList[4],
              value: _StringConverter(
                entity.openInterestChM15?.let((it) => it * 100),
                (original) =>
                    '${original > 0 ? '+' : ''}${original.toStringAsFixed(2)}%',
              )),
          DataGridCell(
              columnName: logic.state.topList[5],
              value: _StringConverter(
                entity.openInterestChM30?.let((it) => it * 100),
                (original) =>
                    '${original > 0 ? '+' : ''}${original.toStringAsFixed(2)}%',
              )),
          DataGridCell(
              columnName: logic.state.topList[6],
              value: _StringConverter(
                entity.openInterestCh1?.let((it) => it * 100),
                (original) =>
                    '${original > 0 ? '+' : ''}${original.toStringAsFixed(2)}%',
              )),
          DataGridCell(
              columnName: logic.state.topList[7],
              value: _StringConverter(
                entity.openInterestCh4?.let((it) => it * 100),
                (original) =>
                    '${original > 0 ? '+' : ''}${original.toStringAsFixed(2)}%',
              )),
          DataGridCell(
              columnName: logic.state.topList[8],
              value: _StringConverter(
                entity.openInterestCh2D?.let((it) => it * 100),
                (original) =>
                    '${original > 0 ? '+' : ''}${original.toStringAsFixed(2)}%',
              )),
          DataGridCell(
              columnName: logic.state.topList[9],
              value: _StringConverter(
                entity.openInterestCh3D?.let((it) => it * 100),
                (original) =>
                    '${original > 0 ? '+' : ''}${original.toStringAsFixed(2)}%',
              )),
          DataGridCell(
              columnName: logic.state.topList[10],
              value: _StringConverter(
                entity.openInterestCh7D?.let((it) => it * 100),
                (original) =>
                    '${original > 0 ? '+' : ''}${original.toStringAsFixed(2)}%',
              ))
        ];
      }
      return DataGridRow(cells: cells);
    }).toList();
    updateDataSource();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Builder(builder: (context) {
        return Container(
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
        );
      }),
      DataGridPriceText(
          (row.getCells()[1].value as _StringConverter).convertedValue.trim(),
          value: (row.getCells()[1].value as _StringConverter).value),
      DataGridRateText(
          (row.getCells()[2].value as _StringConverter).convertedValue.trim(),
          value: (row.getCells()[2].value as _StringConverter).value),
      if (logic.state.isPrice) ...[
        for (var i = 3; i < 8; i++)
          DataGridRateText(
              (row.getCells()[i].value as _StringConverter).convertedValue,
              value: (row.getCells()[i].value as _StringConverter).value),
      ] else ...[
        DataGridNormalText((row.getCells()[3].value as _StringConverter)
            .convertedValue
            .trim()),
        for (var i = 4; i < 12; i++)
          DataGridRateText(
              (row.getCells()[i].value as _StringConverter).convertedValue,
              value: (row.getCells()[i].value as _StringConverter).value),
      ],
    ]);
  }

  /// Update DataSource
  void updateDataSource() {
    notifyListeners();
    notifyDataSourceListeners();
  }
}

class _StringConverter {
  final double? value;
  final String Function(double original) converter;

  _StringConverter(this.value, this.converter);

  bool get isRate =>
      (value is double) &&
      (['-', '+'].any((e) => converter(value ?? 0).startsWith(e)) ||
          converter(value ?? 0) == '0.00%');

  String get convertedValue => converter(value ?? 0);

  @override
  String toString() {
    if (isRate) return '  +200.00%  ';
    return '  ${converter(value ?? 0)}  ';
  }
}
