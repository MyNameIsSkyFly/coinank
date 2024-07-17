part of 'coin_detail_spot_view.dart';

class _DataGridView extends StatelessWidget {
  const _DataGridView({
    required this.logic,
  });

  final CoinDetailSpotLogic logic;

  List<GridColumn> getColumns(BuildContext context) {
    return [
      GridColumn(
          columnName: '1',
          width: 110,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
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
            padding: const EdgeInsets.all(8),
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
            padding: const EdgeInsets.all(8),
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
            padding: const EdgeInsets.all(8),
            child: Text(
              '${S.of(context).s_24h_chg}(%)',
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          columnName: '5',
          width: 110,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            child: Text(
              S.of(context).s_24h_turnover,
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AliveWidget(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: SfTheme(
          data: SfThemeData(
              dataGridThemeData: SfDataGridThemeData(
                  frozenPaneLineColor: Colors.transparent,
                  sortIcon: Builder(
                    builder: (context) {
                      Widget? icon;
                      var columnName = '';
                      context.visitAncestorElements((element) {
                        if (element is GridHeaderCellElement) {
                          columnName = element.column.columnName;
                        }
                        return true;
                      });
                      final column = logic.gridSource.sortedColumns
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
              columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
              source: logic.gridSource,
              columns: getColumns(context)),
        ),
      ),
    );
  }
}
