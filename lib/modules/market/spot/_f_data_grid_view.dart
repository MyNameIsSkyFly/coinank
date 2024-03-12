part of 'spot_view.dart';

class _FDataGridView extends StatefulWidget {
  const _FDataGridView({
    required this.logic,
  });

  final SpotLogic logic;

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
            source: widget.logic.gridSourceF,
            // ignore: invalid_use_of_protected_member
            columns: widget.logic.columnsF.value,
            columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
            onCellTap: (details) {
              if (details.rowColumnIndex.rowIndex == 0) return;
              var baseCoin = widget.logic.gridSourceF
                  .effectiveRows[details.rowColumnIndex.rowIndex - 1]
                  .getCells()[0]
                  .value;
              final item = widget.logic.dataF
                  .firstWhereOrNull((element) => element.baseCoin == baseCoin);
              if (item == null) return;
              AppNav.toCoinDetail(item, toSpot: true);
            },
            onCellLongPress: (details) {
              if (details.rowColumnIndex.rowIndex == 0) return;
              var baseCoin = widget.logic.gridSourceF
                  .effectiveRows[details.rowColumnIndex.rowIndex - 1]
                  .getCells()[0]
                  .value;
              final item = widget.logic.dataF
                  .firstWhereOrNull((element) => element.baseCoin == baseCoin);
              if (item == null) return;
              late bool marked;
              if (StoreLogic.isLogin) {
                marked = item.follow == true;
              } else {
                marked = StoreLogic.to.favoriteSpot.contains(item.baseCoin);
              }
              showOverlayAt(details.globalPosition, marked, onTap: () {
                Get.find<SpotLogic>().tapCollectF(item.baseCoin);
              });
            }),
      );
    });
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
