import 'dart:async';

import 'package:ank_app/entity/event/theme_event.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/market_datagrid_sizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'contract_coin_base_logic.dart';

class ContractCoinGridView extends StatefulWidget {
  const ContractCoinGridView({
    super.key,
    required this.logic,
  });

  final ContractCoinBaseLogic logic;

  @override
  State<ContractCoinGridView> createState() => _ContractCoinGridViewState();
}

class _ContractCoinGridViewState extends State<ContractCoinGridView> {
  StreamSubscription? _localeChangeSubscription;
  final dataGridCtrl = DataGridController();

  @override
  void initState() {
    _localeChangeSubscription =
        AppConst.eventBus.on<ThemeChangeEvent>().listen((event) {
      widget.logic.dataSource.getColumns(context);
      widget.logic.dataSource.buildDataGridRows();
    });
    super.initState();
  }

  @override
  void dispose() {
    _localeChangeSubscription?.cancel();
    super.dispose();
  }

  // ContractCoinState get state => widget.logic.state;
  @override
  Widget build(BuildContext context) {
    widget.logic.dataSource.context = context;
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
          headerRowHeight: 32,
          frozenColumnsCount: 1,
          source: widget.logic.dataSource,
          columns: widget.logic.dataSource.columns.value,
          columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
          onCellTap: _handleCellTap,
          onCellLongPress: _handleCellLongPress,
        ),
      );
    });
  }

  void _handleCellLongPress(DataGridCellLongPressDetails details) {
    if (details.rowColumnIndex.rowIndex == 0) return;
    final baseCoin = widget
        .logic.dataSource.effectiveRows[details.rowColumnIndex.rowIndex - 1]
        .getCells()[0]
        .value;
    final item = widget.logic.dataSource.items
        .firstWhereOrNull((element) => element.baseCoin == baseCoin);
    if (item == null) return;
    late bool marked;
    if (StoreLogic.isLogin) {
      marked = item.follow == true;
    } else {
      marked = StoreLogic.to.favoriteContract.contains(item.baseCoin);
    }
    showOverlayAt(details.globalPosition, marked, onTap: () {
      widget.logic.tapCollect(item.baseCoin);
    });
  }

  void _handleCellTap(DataGridCellTapDetails details) {
    if (details.rowColumnIndex.rowIndex == 0) return;
    final baseCoin = widget
        .logic.dataSource.effectiveRows[details.rowColumnIndex.rowIndex - 1]
        .getCells()[0]
        .value;
    final item = widget.logic.dataSource.items
        .firstWhereOrNull((element) => element.baseCoin == baseCoin);
    if (item == null) return;
    AppNav.toCoinDetail(item);
  }

  void showOverlayAt(Offset tapPosition, bool marked, {VoidCallback? onTap}) {
    final overlayState = Overlay.of(context);
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
  const _SortIcon({
    required this.widget,
  });

  final ContractCoinGridView widget;

  @override
  Widget build(BuildContext context) {
    Widget? icon;
    var columnName = '';
    context.visitAncestorElements((element) {
      if (element is GridHeaderCellElement) {
        columnName = element.column.columnName;
      }
      return true;
    });
    final column = widget.logic.dataSource.sortedColumns
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
