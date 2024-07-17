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
  // ignore: invalid_use_of_protected_member
  List<String> get list => widget.logic.state.topList.value;

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
          columnName: '1',
          width: 100,
          allowSorting: false,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8).copyWith(left: 15),
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
  }

  GridColumn _gridColumn(int index) {
    return GridColumn(
        columnName: '${index + 2}',
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 5),
                child: ImageUtil.exchangeImage(list[index],
                    isCircle: true, size: 15)
                // ClipOval(
                //   child: Image.asset(
                //     'assets/images/platform/${list[index].toLowerCase()}.png',
                //     width: 15,
                //   ),
                // ),
                ),
            Text(
              list[index] == 'Okex' ? 'Okx' : list[index],
              style: Styles.tsBody_12m(context),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SfTheme(
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
                    final column = widget.logic.gridSource.sortedColumns
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
          columnWidthMode: ColumnWidthMode.auto,
          rowHeight: widget.logic.state.isHide.value ? 55 : 65,
          frozenColumnsCount: 1,
          horizontalScrollPhysics: const ClampingScrollPhysics(),
          source: widget.logic.gridSource,
          columns: getColumns(),
          columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
          onCellTap: (details) {
            if (details.rowColumnIndex.rowIndex == 0) return;
            final baseCoin = widget.logic.gridSource
                .effectiveRows[details.rowColumnIndex.rowIndex - 1]
                .getCells()[0]
                .value;
            final item = (widget.logic.state.contentOriginalDataList ?? [])
                .firstWhereOrNull((element) => element.symbol == baseCoin);
            if (item == null) return;
            AppNav.openWebUrl(
              url:
                  '${Urls.h5Prefix}/${Urls.webLanguage}fundingRate/hist?coin=${item.symbol}',
              dynamicTitle: true,
              title: item.symbol,
              showLoading: true,
            );
          },
          onCellLongPress: (details) {
            if (details.rowColumnIndex.rowIndex == 0) return;
            final baseCoin = widget.logic.gridSource
                .effectiveRows[details.rowColumnIndex.rowIndex - 1]
                .getCells()[0]
                .value;
            final item = (widget.logic.state.contentOriginalDataList ?? [])
                .firstWhereOrNull((element) => element.symbol == baseCoin);
            if (item == null) return;

            late bool marked;
            if (StoreLogic.isLogin) {
              marked = item.follow == true;
            } else {
              marked = false;
            }
            showOverlayAt(details.globalPosition, marked, onTap: () async {
              if (StoreLogic.isLogin) {
                if (item.follow == true) {
                  await Apis()
                      .postDelFollow(baseCoin: item.symbol ?? '', type: 2);
                  item.follow = false;
                } else {
                  await Apis()
                      .postAddFollow(baseCoin: item.symbol ?? '', type: 2);
                  item.follow = true;
                }
                if (widget.logic.isFavorite.value) {
                  widget.logic.onRefresh(showLoading: true);
                }
              } else {
                AppNav.toLogin();
              }
            });
          },
        ),
      );
    });
  }

  void showOverlayAt(Offset tapPosition, bool marked, {AsyncCallback? onTap}) {
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
