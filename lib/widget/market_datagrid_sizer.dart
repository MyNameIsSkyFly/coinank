import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MarketDataGridSizer extends ColumnSizer {
  @override
  double computeHeaderCellWidth(GridColumn column, TextStyle style) {
    return super.computeHeaderCellWidth(column, const TextStyle(fontSize: 12));
  }

  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue,
      TextStyle textStyle) {
    return super.computeCellWidth(
        column, row, cellValue, const TextStyle(fontSize: 16));
  }

  @override
  double computeHeaderCellHeight(GridColumn column, TextStyle textStyle) {
    return super.computeHeaderCellHeight(column, const TextStyle(fontSize: 12));
  }

  @override
  double computeCellHeight(GridColumn column, DataGridRow row,
      Object? cellValue, TextStyle textStyle) {
    return super.computeCellHeight(
        column, row, cellValue, const TextStyle(fontSize: 16));
  }
}
