import 'package:ank_app/entity/hold_address_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '_datagrid_source.dart';

class DataGridView extends StatelessWidget {
  const DataGridView({
    super.key,
    required this.list,
    this.showChange = true,
  });

  final RxList<HoldAddressItemEntity> list;
  final bool showChange;

  List<GridColumn> getColumns(BuildContext context) {
    List<GridColumn> columns;
    columns = <GridColumn>[
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
          width: 70,
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
          width: 370,
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
    return columns;
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
            columns: getColumns(context)),
      );
    });
  }
}
