import 'package:ank_app/modules/coin_detail/tab_items/coin_detail_overview/coin_detail_overview_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '_datagrid_source.dart';

class DataGridView extends StatelessWidget {
  const DataGridView({
    super.key,
    required this.logic,
  });

  final CoinDetailOverviewLogic logic;

  List<GridColumn> getColumns(BuildContext context) {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridColumn(
          columnName: '1',
          width: 40,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0).copyWith(left: 15),
            child: Text(
              '#',
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          allowSorting: false,
          columnName: '2',
          width: 160,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).coinType,
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          columnName: '3',
          width: 140,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).marketValue,
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          columnName: '4',
          width: 70,
          label: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).changePercent,
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
    ];
    return columns;
  }

  @override
  Widget build(BuildContext context) {
    return AliveWidget(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Obx(() {
          var productDataGridSource =
              GridDataSource(logic.capList.value, logic.baseCoin);
          return SfTheme(
            data: SfThemeData(
                dataGridThemeData: SfDataGridThemeData(
                    frozenPaneLineColor: Colors.transparent)),
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
        }),
      ),
    );
  }
}
