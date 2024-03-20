import 'dart:async';

import 'package:ank_app/entity/event/theme_event.dart';
import 'package:ank_app/modules/market/spot/widgets/spot_coin_base_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/market_datagrid_sizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SpotCoinGridView extends StatefulWidget {
  const SpotCoinGridView({
    super.key,
    required this.logic,
  });

  final SpotCoinBaseLogic logic;

  @override
  State<SpotCoinGridView> createState() => _SpotCoinGridViewState();
}

class _SpotCoinGridViewState extends State<SpotCoinGridView> {
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
    widget.logic.onRefresh(showLoading: true);
    _localeChangeSubscription =
        AppConst.eventBus.on<ThemeChangeEvent>().listen((event) {
      widget.logic.dataSource.getColumns(context);
      widget.logic.dataSource.buildDataGridRows();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.logic.dataSource.context = context;
    return EasyRefresh(
      onRefresh: () async => widget.logic.onRefresh(),
      child: Obx(() {
        return SfTheme(
          data: SfThemeData(
              dataGridThemeData: SfDataGridThemeData(
                  frozenPaneLineColor: Colors.transparent,
                  sortIcon: _SortIcon(widget.logic))),
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
              source: widget.logic.dataSource,
              // ignore: invalid_use_of_protected_member
              columns: widget.logic.dataSource.columns.value,
              columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
              onCellTap: (details) {
                if (details.rowColumnIndex.rowIndex == 0) return;
                var baseCoin = widget.logic.dataSource
                    .effectiveRows[details.rowColumnIndex.rowIndex - 1]
                    .getCells()[0]
                    .value;
                final item = widget.logic.dataSource.items.firstWhereOrNull(
                    (element) => element.baseCoin == baseCoin);
                if (item == null) return;
                AppNav.toCoinDetail(item, toSpot: true);
              },
              onCellLongPress: (details) {
                if (details.rowColumnIndex.rowIndex == 0) return;
                var baseCoin = widget.logic.dataSource
                    .effectiveRows[details.rowColumnIndex.rowIndex - 1]
                    .getCells()[0]
                    .value;
                final item = widget.logic.dataSource.items.firstWhereOrNull(
                    (element) => element.baseCoin == baseCoin);
                if (item == null) return;
                late bool marked;
                if (StoreLogic.isLogin) {
                  marked = item.follow == true;
                } else {
                  marked = StoreLogic.to.favoriteSpot.contains(item.baseCoin);
                }
                showOverlayAt(details.globalPosition, marked, onTap: () {
                  widget.logic.tapCollect(item.baseCoin);
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
  const _SortIcon(this.logic);

  final SpotCoinBaseLogic logic;

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
    var column = logic.dataSource.sortedColumns
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
