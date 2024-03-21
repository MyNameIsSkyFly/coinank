// ignore_for_file: invalid_use_of_protected_member
part of 'coin_detail_hold_view.dart';

class DataGridView extends StatelessWidget {
  const DataGridView({
    super.key,
    required this.list,
    this.showChange = true,
  });

  final RxList<HoldAddressItemEntity> list;
  final bool showChange;

  List<GridColumn> getColumns(BuildContext context) {
    return <GridColumn>[
      GridColumn(
          columnName: '1',
          width: 40,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '#',
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          allowSorting: false,
          columnName: '2',
          width: 100,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).heldCoinNumber,
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          columnName: '3',
          width: 80,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              child: Text(
                S.of(context).ratio,
                overflow: TextOverflow.ellipsis,
                style: Styles.tsSub_12(context),
              ),
            ),
          )),
      if (showChange)
        GridColumn(
            columnName: '4',
            width: 100,
            label: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${S.of(context).s_home_chg} (7D)',
                overflow: TextOverflow.ellipsis,
                style: Styles.tsSub_12(context),
              ),
            )),
      GridColumn(
          columnName: '5',
          width: 120,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).address,
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var productDataGridSource =
          GridDataSource(list.value, showChange: showChange);
      return SfTheme(
        data: SfThemeData(
            dataGridThemeData:
                SfDataGridThemeData(frozenPaneLineColor: Colors.transparent)),
        child: SfDataGrid(
            showHorizontalScrollbar: false,
            showVerticalScrollbar: false,
            gridLinesVisibility: GridLinesVisibility.none,
            headerGridLinesVisibility: GridLinesVisibility.none,
            verticalScrollPhysics: const NeverScrollableScrollPhysics(),
            shrinkWrapRows: true,
            horizontalScrollPhysics: const ClampingScrollPhysics(),
            source: productDataGridSource,
            columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
            columns: getColumns(context)),
      );
    });
  }
}
