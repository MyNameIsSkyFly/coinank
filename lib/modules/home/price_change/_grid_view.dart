part of 'price_change_view.dart';

class _GridView extends StatelessWidget {
  final logic = Get.find<PriceChangeLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SfTheme(
        data: SfThemeData(
            dataGridThemeData: SfDataGridThemeData(
          frozenPaneLineColor: Colors.transparent,
        )),
        child: SfDataGrid(
          source: logic.gridSource,
          columns: logic.columns.value,
          gridLinesVisibility: GridLinesVisibility.none,
          headerGridLinesVisibility: GridLinesVisibility.none,
          columnSizer: MarketDataGridSizer(),
          columnWidthMode: ColumnWidthMode.auto,
          frozenColumnsCount: 1,
          horizontalScrollPhysics: const ClampingScrollPhysics(),
          columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
          onCellTap: (details) {
            if (details.rowColumnIndex.rowIndex == 0) {
              final columnIndex = details.rowColumnIndex.columnIndex;
              logic.tapSort(columnIndex - 1);
              return;
            }
            var baseCoin = logic
                .gridSource.effectiveRows[details.rowColumnIndex.rowIndex - 1]
                .getCells()[0]
                .value;
            final item = logic.state.originalData
                ?.firstWhereOrNull((element) => element.baseCoin == baseCoin);
            if (item == null) return;
            AppNav.toCoinDetail(item);
          },
        ),
      );
    });
  }
}
