import 'dart:math';

import 'package:ank_app/entity/fund_his_list_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/custom_bottom_sheet/custom_bottom_sheet_view.dart';
import 'package:ank_app/widget/selector_chip.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CoinDetailFundFlowView extends StatefulWidget {
  const CoinDetailFundFlowView({
    super.key,
    required this.isSpot,
    required this.baseCoin,
    required this.exchangeName,
  });

  final bool isSpot;
  final String baseCoin;
  final String? exchangeName;

  @override
  State<CoinDetailFundFlowView> createState() => _CoinDetailFundFlowViewState();
}

class _CoinDetailFundFlowViewState extends State<CoinDetailFundFlowView> {
  late final source = _FundFlowGridSource(
      isSpot: widget.isSpot,
      baseCoin: widget.baseCoin,
      exchangeName: widget.exchangeName);

  @override
  void initState() {
    source.initData();
    super.initState();
  }

  //5m,15m,30m,1h.2h,4h,6h,8h,12h,1D,3D,7D,15D,30D
  late final columns = <GridColumn>[
    GridColumn(
      width: 114,
      columnName: S.of(context).time,
      label: Container(
        alignment: Alignment.center,
        child: Text(S.of(context).time, style: Styles.tsSub_12(context)),
      ),
    ),
    _column('5m'),
    _column('15m'),
    _column('30m'),
    _column('1h'),
    _column('2h'),
    _column('4h'),
    _column('6h'),
    _column('8h'),
    _column('12h'),
    _column('1D'),
    _column('3D'),
    _column('7D'),
    _column('15D'),
    _column('30D'),
  ];

  GridColumn _column(String text) {
    return GridColumn(
      width: 110,
      columnName: text,
      label: _label(text),
    );
  }

  Widget _label(String text) {
    return Container(
      alignment: Alignment.center,
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AliveWidget(
      child: Column(
        children: [
          Container(
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(child: Text(S.of(context).funds)),
                StatefulBuilder(builder: (context, setState) {
                  return SelectorChip(
                      onTap: () async {
                        final result = await showCupertinoModalPopup(
                          context: context,
                          builder: (context) => const CustomSelector(
                            title: '',
                            dataList: [
                              '5m',
                              '15m',
                              '30m',
                              '1h',
                              '2h',
                              '4h',
                              '6h',
                              '8h',
                              '12h',
                              '1d'
                            ],
                          ),
                        );

                        if (result != null) {
                          source.interval = result;
                          source.initData();
                          setState(() {});
                        }
                      },
                      text: source.interval);
                })
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SfTheme(
                data: SfThemeData(
                  dataGridThemeData: const SfDataGridThemeData(
                    frozenPaneLineColor: Colors.transparent,
                  ),
                ),
                child: SfDataGrid(
                  source: source,
                  columns: columns,
                  verticalScrollPhysics: const NeverScrollableScrollPhysics(),
                  shrinkWrapRows: true,
                  rowHeight: 50,
                  headerRowHeight: 27,
                  frozenColumnsCount: 1,
                  gridLinesVisibility: GridLinesVisibility.none,
                  headerGridLinesVisibility: GridLinesVisibility.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FundFlowGridSource extends DataGridSource {
  _FundFlowGridSource({
    required this.isSpot,
    required this.baseCoin,
    required this.exchangeName,
  });

  final bool isSpot;
  final String baseCoin;
  final String? exchangeName;
  var interval = '5m';

  final items = <FundHisListEntity>[];

  Future<void> initData() async {
    final result = await Apis().getFundHisList(
      interval: interval.toLowerCase(),
      size: 100,
      baseCoin: baseCoin,
      exchangeName: exchangeName,
      endTime: DateTime.now().millisecondsSinceEpoch,
      productType: isSpot ? 'SPOT' : 'SWAP',
    );
    final list = result ?? [];
    items.addAll(list);
    notifyListeners();
    notifyDataSourceListeners();
  }

  @override
  List<DataGridRow> get rows {
    //5m,15m,30m,1h.2h,4h,6h,8h,12h,1D,3D,7D,15D,30D
    return items.reversed.mapIndexed((index, e) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: S.current.time, value: e.ts),
        DataGridCell<double>(columnName: '5m', value: e.m5net),
        DataGridCell<double>(columnName: '15m', value: e.m15net),
        DataGridCell<double>(columnName: '30m', value: e.m30net),
        DataGridCell<double>(columnName: '1h', value: e.h1net),
        DataGridCell<double>(columnName: '2h', value: e.h2net),
        DataGridCell<double>(columnName: '4h', value: e.h4net),
        DataGridCell<double>(columnName: '6h', value: e.h6net),
        DataGridCell<double>(columnName: '8h', value: e.h8net),
        DataGridCell<double>(columnName: '12h', value: e.h12net),
        DataGridCell<double>(columnName: '1D', value: e.d1net),
        DataGridCell<double>(columnName: '3D', value: e.d3net),
        DataGridCell<double>(columnName: '7D', value: e.d7net),
        DataGridCell<double>(columnName: '15D', value: e.d15net),
        DataGridCell<double>(columnName: '30D', value: e.d30net),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    var cells = row.getCells();

    var sublist = cells.sublist(1);
    final maxValue = sublist.map((e) => e.value as double).reduce(max);
    final minValue = sublist.map((e) => e.value as double).reduce(min);

    return DataGridRowAdapter(
        cells: cells.mapIndexed((index, e) {
      if (index == 0) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Builder(builder: (context) {
            return Text(
                DateFormat('MM-dd HH:mm')
                    .format(DateTime.fromMillisecondsSinceEpoch(e.value)),
                style: Styles.tsBody_14m(context));
          }),
        );
      }
      return Builder(builder: (context) {
        var value = e.value as double;
        return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(1),
          color: value >= 0
              ? Styles.cUp(context)
                  .withOpacity((value / maxValue).clamp(0.25, 1))
              : Styles.cDown(context)
                  .withOpacity((value / minValue).clamp(0.25, 1)),
          child: Text(
            AppUtil.getLargeFormatString(value, precision: 2),
            style: Styles.tsBody_14m(context),
          ),
        );
      });
    }).toList());
  }
}
