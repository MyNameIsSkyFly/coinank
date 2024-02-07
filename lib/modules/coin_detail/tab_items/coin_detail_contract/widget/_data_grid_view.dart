import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../res/export.dart';
import '../coin_detail_contract_logic.dart';

class DataGridView extends StatefulWidget {
  const DataGridView({
    super.key,
    required this.logic,
  });

  final CoinDetailContractLogic logic;

  @override
  State<DataGridView> createState() => _DataGridViewState();
}

class _DataGridViewState extends State<DataGridView> {
  List<GridColumn> getColumns(BuildContext context) {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridColumn(
          columnName: '1',
          width: 120,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0).copyWith(left: 15),
            child: Text(
              S.of(context).s_exchange_name,
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
              S.of(context).symbol,
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
              '${S.of(context).s_price}(\$)',
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
              '${S.of(context).s_24h_chg}(%)',
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          columnName: '5',
          width: 110,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                S.of(context).s_24h_turnover,
                style: Styles.tsSub_12(context),
              ),
            ),
          )),
      GridColumn(
          columnName: '6',
          width: 90,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${S.of(context).s_oi}(\$)',
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          columnName: '7',
          width: 100,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '24H(%)',
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          columnName: '8',
          width: 100,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).s_funding_rate,
              style: Styles.tsSub_12(context),
            ),
          )),
    ];
    return columns;
  }


  Widget _text(String text, int index) {
    return GestureDetector(
      onTap: () {
        widget.logic.typeIndex.value = index;
        widget.logic.gridSource.setGridType(index);
      },
      child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            text.toUpperCase(),
            style: index == widget.logic.typeIndex.value
                ? Styles.tsMain_14m
                : Styles.tsSub_14m(context),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AliveWidget(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(15),
            Obx(() {
              return Row(
                children: [
                  _text(S.of(context).s_all, 0),
                  _text(S.of(context).s_swap, 1),
                  _text(S.of(context).s_futures, 2),
                ],
              );
            }),
            SfTheme(
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
                          var column = widget.logic.gridSource.sortedColumns
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
                  allowSorting: true,
                  allowTriStateSorting: true,
                  shrinkWrapRows: true,
                  frozenColumnsCount: 1,
                  horizontalScrollPhysics: const ClampingScrollPhysics(),
                  source: widget.logic.gridSource,
                  columns: getColumns(context)),
            ),
          ],
        ),
      ),
    );
  }
}
