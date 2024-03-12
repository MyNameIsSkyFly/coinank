part of 'spot_view.dart';

class _DataGridView extends StatefulWidget {
  const _DataGridView({
    required this.logic,
  });

  final SpotLogic logic;

  @override
  State<_DataGridView> createState() => _DataGridViewState();
}

class _DataGridViewState extends State<_DataGridView> {
  late List<GridColumn> columns;

  final dataGridCtrl = DataGridController();
  StreamSubscription? _localeChangeSubscription;
  StreamSubscription? _refreshSubscription;

  @override
  void dispose() {
    _refreshSubscription?.cancel();
    _localeChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    widget.logic.getMarketData(showLoading: true);
    _localeChangeSubscription =
        AppConst.eventBus.on<ThemeChangeEvent>().listen((event) {
      widget.logic.getColumns(context);
      widget.logic.gridSource.buildDataGridRows();
    });
    _refreshSubscription =
        AppConst.eventBus.on<EventCoinMarked>().listen((event) {
      if (event.isSpot) return;
      widget.logic.getMarketDataF();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.logic.gridSource.context = context;
    return EasyRefresh(
      onRefresh: () async => widget.logic.getMarketData(),
      child: Obx(() {
        return SfTheme(
          data: SfThemeData(
              dataGridThemeData: SfDataGridThemeData(
                  frozenPaneLineColor: Colors.transparent,
                  sortIcon: const _SortIcon())),
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
              source: widget.logic.gridSource,
              // ignore: invalid_use_of_protected_member
              columns: widget.logic.columns.value,
              columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
              onCellTap: (details) {
                if (details.rowColumnIndex.rowIndex == 0) return;
                var baseCoin = widget.logic.gridSource
                    .effectiveRows[details.rowColumnIndex.rowIndex - 1]
                    .getCells()[0]
                    .value;
                final item = widget.logic.data.firstWhereOrNull(
                    (element) => element.baseCoin == baseCoin);
                if (item == null) return;
                AppNav.toCoinDetail(item, toSpot: true);
              },
              onCellLongPress: (details) {
                if (details.rowColumnIndex.rowIndex == 0) return;
                var baseCoin = widget.logic.gridSource
                    .effectiveRows[details.rowColumnIndex.rowIndex - 1]
                    .getCells()[0]
                    .value;
                final item = widget.logic.data.firstWhereOrNull(
                    (element) => element.baseCoin == baseCoin);
                if (item == null) return;
                late bool marked;
                if (StoreLogic.isLogin) {
                  marked = item.follow == true;
                } else {
                  marked = StoreLogic.to.favoriteSpot.contains(item.baseCoin);
                }
                showOverlayAt(details.globalPosition, marked, onTap: () {
                  Get.find<SpotLogic>().tapCollect(item);
                });
              }),
        );
      }),
    );
  }

  void showOverlayAt(Offset tapPosition, bool marked, {VoidCallback? onTap}) {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => SizedBox.expand(
        child: Stack(
          children: [
            ModalBarrier(onDismiss: () => overlayEntry?.remove()),
            Positioned(
              left: tapPosition.dx - 24,
              top: tapPosition.dy - 48,
              child: GestureDetector(
                onTap: () {
                  onTap?.call();
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
  const _SortIcon();

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<SpotLogic>();
    Widget? icon;
    String columnName = '';
    context.visitAncestorElements((element) {
      if (element is GridHeaderCellElement) {
        columnName = element.column.columnName;
      }
      return true;
    });
    var column = logic.gridSource.sortedColumns
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
