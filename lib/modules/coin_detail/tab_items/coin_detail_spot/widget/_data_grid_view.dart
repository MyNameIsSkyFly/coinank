import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../res/export.dart';
import '../coin_detail_spot_logic.dart';
import '_datagrid_source.dart';

class DataGridView extends StatelessWidget {
  const DataGridView({
    super.key,
    required this.logic,
  });

  final CoinDetailSpotLogic logic;

  List<GridColumn> getColumns(BuildContext context) {
    List<GridColumn> columns;
    columns = <GridColumn>[
      //todo intl
      GridColumn(
          columnName: '1',
          width: 110,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '交易所',
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          allowSorting: false,
          columnName: '2',
          width: 150,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '货币',
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          columnName: '3',
          width: 100,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '价格\$',
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          columnName: '4',
          width: 100,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '24H变化(%)',
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          columnName: '5',
          width: 110,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '24H成交额',
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
    ];
    return columns;
  }

  @override
  Widget build(BuildContext context) {
    return AliveWidget(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Obx(() {
          var productDataGridSource =
              GridDataSource(logic.coin24HDataList.value, logic.baseCoin);
          return SfTheme(
            data: SfThemeData(
                dataGridThemeData: SfDataGridThemeData(
                    frozenPaneLineColor: Colors.transparent,
                    sortIcon: Builder(
                      builder: (context) {
                        Widget? icon;
                        String columnName = '';
                        context.visitAncestorElements((element) {
                          if (element is GridHeaderCellElement) {
                            columnName = element.column.columnName;
                          }
                          return true;
                        });
                        var column = productDataGridSource.sortedColumns
                            .where((element) => element.name == columnName)
                            .firstOrNull;
                        if (column != null) {
                          if (column.sortDirection ==
                              DataGridSortDirection.ascending) {
                            icon = Image.asset(Assets.commonIconSortUp,
                                width: 9, height: 12);
                          } else if (column.sortDirection ==
                              DataGridSortDirection.descending) {
                            icon = Image.asset(Assets.commonIconSortDown,
                                width: 9, height: 12);
                          }
                        }
                        return icon ??
                            Image.asset(Assets.commonIconSortN,
                                width: 9, height: 12);
                      },
                    ))),
            child: SfDataGrid(
                showHorizontalScrollbar: false,
                showVerticalScrollbar: false,
                gridLinesVisibility: GridLinesVisibility.none,
                headerGridLinesVisibility: GridLinesVisibility.none,
                verticalScrollPhysics: const NeverScrollableScrollPhysics(),
                shrinkWrapRows: true,
                frozenColumnsCount: 1,
                allowTriStateSorting: true,
                allowSorting: true,
                horizontalScrollPhysics: const ClampingScrollPhysics(),
                source: productDataGridSource,
                columns: getColumns(context)),
          );
        }),
      ),
    );
  }
}
