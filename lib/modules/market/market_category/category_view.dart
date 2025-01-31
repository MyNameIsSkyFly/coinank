import 'dart:async';

import 'package:ank_app/entity/category_grid_entity.dart';
import 'package:ank_app/entity/event/theme_event.dart';
import 'package:ank_app/modules/main/main_logic.dart';
import 'package:ank_app/modules/market/spot/spot_logic.dart';
import 'package:ank_app/modules/market/utils/text_maps.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/app_refresh.dart';
import 'package:ank_app/widget/data_grid_widgets.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../contract/contract_logic.dart';
import '../market_logic.dart';

part 'category_logic.dart';

class ContractCategoryPage extends StatefulWidget {
  const ContractCategoryPage({super.key, this.isSpot = false});

  final bool isSpot;

  @override
  State<ContractCategoryPage> createState() => _ContractCategoryPageState();
}

class _ContractCategoryPageState extends State<ContractCategoryPage>
    with ContractCategoryLogic {
  @override
  void initState() {
    isSpot = widget.isSpot;
    onInit();
    super.initState();
  }

  @override
  void dispose() {
    onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppRefresh(
      onRefresh: () async => initData(),
      child: Obx(() {
        return SfTheme(
          data: SfThemeData(
              dataGridThemeData: SfDataGridThemeData(
                  frozenPaneLineColor: Colors.transparent,
                  sortIcon: _SortIcon(gridSource))),
          child: SfDataGrid(
            source: gridSource,
            columns: columns.value,
            columnWidthMode: ColumnWidthMode.auto,
            allowTriStateSorting: true,
            allowSorting: true,
            frozenColumnsCount: 1,
            columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
            horizontalScrollPhysics: const ClampingScrollPhysics(),
            headerRowHeight: 32,
            gridLinesVisibility: GridLinesVisibility.none,
            rowHeight: 55,
            headerGridLinesVisibility: GridLinesVisibility.none,
            onCellTap: (details) {
              if (details.rowColumnIndex.rowIndex == 0) return;
              final tagText = (gridSource
                      .effectiveRows[details.rowColumnIndex.rowIndex - 1]
                      .getCells()[0]
                      .value as _TextValue)
                  .text;
              String? tag;
              for (var i = 0; i < categoryTags.length; i++) {
                if (MarketMaps.categoryTextMap(categoryTags[i]) == tagText) {
                  tag = categoryTags[i];
                  break;
                }
              }
              AppNav.toCategoryDetail(tag: tag, isSpot: widget.isSpot);
            },
          ),
        );
      }),
    );
  }
}

class _DataGridSource extends DataGridSource {
  final List<DataGridRow> _dataGridRows = [];
  final list = <CategoryGridEntity>[];
  bool isSpot = false;

  //buildDataGridRows
  void buildDataGridRows() {
    DataGridCell<dynamic> cell(String text,
        {required String columnName, required double? value}) {
      return DataGridCell(
          columnName: columnName, value: _TextValue(text, value ?? 0));
    }

    _dataGridRows
      ..clear()
      ..addAll(list.mapIndexed((index, e) {
        final item = list[index];
        return DataGridRow(cells: [
          cell(MarketMaps.categoryTextMap(item.tag),
              columnName: S.current.category, value: null),
          cell('\$${AppUtil.getLargeFormatString('${item.turnover}')}',
              columnName: '${S.current.s_24h_turnover}(\$)',
              value: item.turnover),
          cell(
              '${(item.turnoverChg ?? 0) >= 0 ? '+' : ''}${item.turnoverChg?.toStringAsFixed(2)}%',
              columnName: '${S.current.s_24h_turnover}(%)',
              value: item.turnoverChg),
          if (!isSpot) ...[
            cell('\$${AppUtil.getLargeFormatString('${item.openInterest}')}',
                columnName: '${S.current.s_oi}(\$)', value: item.openInterest),
            cell(
                '${(item.openInterestCh1 ?? 0) >= 0 ? '+' : ''}${((item.openInterestCh1 ?? 0) * 100).toStringAsFixed(2)}%',
                columnName: '${S.current.s_oi}(1H%)',
                value: (item.openInterestCh1 ?? 0) * 100),
            cell(
                '${(item.openInterestCh24 ?? 0) >= 0 ? '+' : ''}${((item.openInterestCh24 ?? 0) * 100).toStringAsFixed(2)}%',
                columnName: '${S.current.s_oi}(24H%)',
                value: (item.openInterestCh24 ?? 0) * 100)
          ],
          cell('\$${AppUtil.getLargeFormatString('${item.marketCap}')}',
              columnName: '${S.current.marketCap}(\$)', value: item.marketCap),
          DataGridCell(
              columnName: S.current.topMarketCoin,
              value: _TextValue(
                  '${item.topMarketCoin} ${AppUtil.getLargeFormatString('${item.topMarket}')}',
                  item.topMarket ?? 0,
                  lengthHelper: '       ${item.topMarketCoin} ${AppUtil.getLargeFormatString('${item.topMarket}')}',
                  extras: {'coin': item.topMarketCoin})),
          DataGridCell(
              columnName: S.current.topGainerCoin,
              value: _TextValue('${item.bestChg}', item.bestChg ?? 0,
                  lengthHelper: '       ${item.bestCoin} ${item.bestChg}%',
                  extras: {'coin': item.bestCoin, 'chg': item.bestChg})),
          // cell('${item.bestChg}',
          //     columnName: S.current.topGainerCoin, value: item.bestChg),
        ]);
      }));
  }

  void refresh() {
    buildDataGridRows();
    notifyListeners();
    notifyDataSourceListeners();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      DataGridNormalText(row.getCells()[0].value.toString()),
      DataGridNormalText(row.getCells()[1].value.toString()),
      DataGridRateText(
        row.getCells()[2].value.toString(),
        value: (row.getCells()[2].value as _TextValue).value,
      ),
      if (!isSpot) ...[
        DataGridNormalText(row.getCells()[3].value.toString()),
        DataGridRateText(
          row.getCells()[4].value.toString(),
          value: (row.getCells()[4].value as _TextValue).value,
        ),
        DataGridRateText(
          row.getCells()[5].value.toString(),
          value: (row.getCells()[5].value as _TextValue).value,
        )
      ],
      DataGridNormalText(row.getCells()[isSpot ? 3 : 6].value.toString()),
      Builder(builder: (context) {
        final value = row.getCells()[isSpot ? 4 : 7].value as _TextValue;
        return Row(
          children: [
            ImageUtil.coinImage(value.extras?['coin'] ?? '', size: 24),
            const Gap(4),
            Expanded(
              child: Text(value.text ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.tsBody_16m(context)),
            ),
          ],
        );
      }),
      Builder(builder: (context) {
        final value = row.getCells()[isSpot ? 5 : 8].value as _TextValue;
        final chg = (value.extras?['chg'] as double?) ?? 0;
        final coin = (value.extras?['coin'] as String?) ?? '';
        return Row(
          children: [
            ImageUtil.coinImage(value.extras?['coin'] ?? '', size: 24),
            const Gap(4),
            Text(coin,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Styles.tsBody_16m(context)),
            const Gap(4),
            Expanded(
              child: Text(
                '${chg.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 16,
                  color: chg >= 0 ? Styles.cUp(context) : Styles.cDown(context),
                  fontWeight: Styles.fontMedium,
                ),
              ),
            ),
          ],
        );
      }),
    ]);
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    final valueA = (a
                ?.getCells()
                .firstWhereOrNull(
                    (element) => element.columnName == sortColumn.name)
                ?.value as _TextValue?)
            ?.value ??
        (sortColumn.sortDirection == DataGridSortDirection.ascending
            ? 10
            : -10);
    final valueB = (b
                ?.getCells()
                .firstWhereOrNull(
                    (element) => element.columnName == sortColumn.name)
                ?.value as _TextValue?)
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

class _TextValue {
  final String? text;
  final double? value;
  final String? lengthHelper;
  final Map<String, dynamic>? extras;

  _TextValue(this.text, this.value, {this.lengthHelper, this.extras});

  @override
  String toString() {
    return '${lengthHelper ?? text}';
  }
}

class _SortIcon extends StatelessWidget {
  const _SortIcon(this.dataSource);

  final _DataGridSource dataSource;

  @override
  Widget build(BuildContext context) {
    Widget? icon;
    var columnName = '';
    context.visitAncestorElements((element) {
      if (element is GridHeaderCellElement) {
        columnName = element.column.columnName;
      }
      return true;
    });
    final column = dataSource.sortedColumns
        .where((element) => element.name == columnName)
        .firstOrNull;
    if (column != null) {
      if (column.sortDirection == DataGridSortDirection.ascending) {
        icon = Image.asset(Assets.commonIconSortUp, width: 9, height: 12);
      } else if (column.sortDirection == DataGridSortDirection.descending) {
        icon = Image.asset(Assets.commonIconSortDown, width: 9, height: 12);
      }
    }
    return icon ?? Image.asset(Assets.commonIconSortN, width: 9, height: 12);
  }
}
