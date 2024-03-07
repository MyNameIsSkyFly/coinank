part of 'favorite_coin_view.dart';

class _FDataGridView extends StatefulWidget {
  const _FDataGridView({
    required this.logic,
  });

  final ContractCoinLogic logic;

  @override
  State<_FDataGridView> createState() => _FDataGridViewState();
}

class _FDataGridViewState extends State<_FDataGridView> {
  late List<GridColumn> columns;

  StreamSubscription? _localeChangeSubscription;
  final dataGridCtrl = DataGridController();

  @override
  void initState() {
    _localeChangeSubscription =
        AppConst.eventBus.on<ThemeChangeEvent>().listen((event) {
      widget.logic.getColumns(context);
      widget.logic.gridSourceF.buildDataGridRows();
    });
    super.initState();
  }

  @override
  void dispose() {
    _localeChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.logic.gridSourceF.context = context;
    return Obx(() {
      return SfTheme(
        data: SfThemeData(
            dataGridThemeData: SfDataGridThemeData(
                frozenPaneLineColor: Colors.transparent,
                sortIcon: _SortIcon(widget: widget))),
        child: SfDataGrid(
          controller: dataGridCtrl,
          gridLinesVisibility: GridLinesVisibility.none,
          headerGridLinesVisibility: GridLinesVisibility.none,
          columnSizer: MarketDataGridSizer(),
          allowSorting: true,
          allowTriStateSorting: true,
          columnWidthMode: ColumnWidthMode.auto,
          frozenColumnsCount: 1,
          horizontalScrollPhysics: const ClampingScrollPhysics(),
          source: widget.logic.gridSourceF,
          columns: widget.logic.fColumns.value,
          columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
          onCellTap: (details) {
            if (details.rowColumnIndex.rowIndex == 0) return;
            var baseCoin = widget.logic.gridSourceF
                .effectiveRows[details.rowColumnIndex.rowIndex - 1]
                .getCells()[0]
                .value;
            final item = widget.logic.state.favoriteData
                .firstWhereOrNull((element) => element.baseCoin == baseCoin);
            if (item == null) return;
            AppNav.toCoinDetail(item);
          },
          onCellLongPress: (details) {
            if (details.rowColumnIndex.rowIndex == 0) return;
            var baseCoin = widget.logic.gridSourceF
                .effectiveRows[details.rowColumnIndex.rowIndex - 1]
                .getCells()[0]
                .value;
            final item = widget.logic.state.favoriteData
                .firstWhereOrNull((element) => element.baseCoin == baseCoin);
            if (item == null) return;

            late bool marked;
            if (StoreLogic.isLogin) {
              marked = item.follow == true;
            } else {
              marked = StoreLogic.to.favoriteContract.contains(item.baseCoin);
            }
            showOverlayAt(details.globalPosition, marked, onTap: () async {
              await Get.find<ContractCoinLogic>().tapCollectF(item.baseCoin);
            });
          },
        ),
      );
    });
  }

  void showOverlayAt(Offset tapPosition, bool marked, {AsyncCallback? onTap}) {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            ModalBarrier(onDismiss: () => overlayEntry?.remove()),
            Positioned(
              left: tapPosition.dx - 24,
              top: tapPosition.dy - 48,
              child: GestureDetector(
                onTap: () async {
                  await onTap?.call();
                  overlayEntry?.remove();
                },
                child: SizedBox(
                  width: 48,
                  height: 43,
                  child: Stack(
                    children: [
                      Image.asset(Assets.commonIcBlueBubble),
                      Align(
                        alignment: const Alignment(0, -0.3),
                        child: ImageIcon(
                            AssetImage(marked
                                ? Assets.commonIconStarFill
                                : Assets.commonIconStar),
                            color: marked ? Styles.cYellow : Colors.white,
                            size: 20),
                      )
                    ],
                  ),
                ),
              ), // Replace with your widget
            ),
          ],
        ),
      ),
    );
    overlayState.insert(
      overlayEntry,
    );
  }
}

class _SortIcon extends StatelessWidget {
  const _SortIcon({
    required this.widget,
  });

  final _FDataGridView widget;

  @override
  Widget build(BuildContext context) {
    Widget? icon;
    String columnName = '';
    context.visitAncestorElements((element) {
      if (element is GridHeaderCellElement) {
        columnName = element.column.columnName;
      }
      return true;
    });
    var column = widget.logic.gridSourceF.sortedColumns
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
