import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../res/export.dart';
import '../coin_detail_contract_logic.dart';
import 'datagrid_source.dart';

class DataGridView extends StatelessWidget {
  const DataGridView({
    super.key,
    required this.logic,
  });

  final CoinDetailContractLogic logic;

  List<GridColumn> getColumns(BuildContext context) {
    List<GridColumn> columns;
    columns = <GridColumn>[
      //todo intl
      GridColumn(
          columnName: '1',
          width: 110,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '交易所',
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          columnName: '2',
          width: 150,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '货币',
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          columnName: '3',
          width: 100,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '价格\$',
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          columnName: '4',
          width: 100,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '24H变化(%)',
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          columnName: '5',
          width: 110,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '24H成交额',
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          columnName: '6',
          width: 90,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '持仓(\$)',
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          columnName: '7',
          width: 100,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '24H(%)',
              overflow: TextOverflow.ellipsis,
              style: Styles.tsSub_12(context),
            ),
          )),
      GridColumn(
          columnName: '8',
          width: 100,
          label: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '资金费率',
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
        child: Obx(() {
          return SfTheme(
            data: SfThemeData(
                dataGridThemeData: SfDataGridThemeData(
              frozenPaneLineColor: Colors.transparent,
            )),
            child: SfDataGrid(
                gridLinesVisibility: GridLinesVisibility.none,
                headerGridLinesVisibility: GridLinesVisibility.none,
                verticalScrollPhysics: const NeverScrollableScrollPhysics(),
                shrinkWrapRows: true,
                frozenColumnsCount: 1,
                horizontalScrollPhysics: const ClampingScrollPhysics(),
                source: ProductDataGridSource(
                    logic.coin24HDataList.value, logic.baseCoin),
                columns: getColumns(context)),
          );
        }),
      ),
    );
  }
}
