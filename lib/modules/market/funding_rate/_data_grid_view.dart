part of 'funding_rate_view.dart';

class _DataGridView extends StatefulWidget {
  const _DataGridView({
    required this.logic,
  });

  final FundingRateLogic logic;

  @override
  State<_DataGridView> createState() => _DataGridViewState();
}

class _DataGridViewState extends State<_DataGridView> {
  List get list => widget.logic.state.topList.value;

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    int index = 0;
    columns = <GridColumn>[
      GridColumn(
          columnName: '1',
          width: 100,
          allowSorting: false,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0).copyWith(left: 15),
            child: Text(
              'Coin',
              overflow: TextOverflow.ellipsis,
              style: Styles.tsBody_12m(context),
            ),
          )),
      _gridColumn(0),
      _gridColumn(1),
      _gridColumn(2),
      _gridColumn(3),
      _gridColumn(4),
      _gridColumn(5),
      _gridColumn(6),
    ];
    return columns;
  }

  GridColumn _gridColumn(int index) {
    return GridColumn(
        columnName: '${index + 2}',
        width: 100,
        label: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/platform/${list[index].toLowerCase()}.png',
                    width: 15,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    child: Text(
                      list[index],
                      style: Styles.tsBody_12m(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SfTheme(
        data: SfThemeData(
            dataGridThemeData: SfDataGridThemeData(
                frozenPaneLineColor: Styles.cSub(context).withOpacity(0.2),
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
            verticalScrollController: widget.logic.state.scrollController,
            gridLinesVisibility: GridLinesVisibility.none,
            headerGridLinesVisibility: GridLinesVisibility.none,
            allowSorting: true,
            allowTriStateSorting: true,
            rowHeight: widget.logic.state.isHide.value ? 55 : 65,
            frozenColumnsCount: 1,
            horizontalScrollPhysics: const ClampingScrollPhysics(),
            source: widget.logic.gridSource,
            columns: getColumns()),
      );
    });
  }
}
