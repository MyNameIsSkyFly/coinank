import 'package:ank_app/entity/oi_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ExchangeOiGridSource extends DataGridSource {
  List<DataGridRow> dataGridRows = <DataGridRow>[];
  String _baseCoin = 'BTC';
  final oiList = <OIEntity>[];

  ExchangeOiGridSource();

  void buildDataRows() {
    dataGridRows = oiList
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'exchange', value: e.exchangeName),
              DataGridCell(columnName: 'oi', value: (e.coinValue, e.coinCount)),
              DataGridCell(columnName: 'rate', value: e.rate),
              DataGridCell(columnName: 'change1H', value: e.change1H),
              DataGridCell(columnName: 'change4H', value: e.change4H),
              DataGridCell(columnName: 'change24H', value: e.change24H),
            ]))
        .toList();
    notifyDataSourceListeners();
  }

  set baseCoin(String value) {
    _baseCoin = value;
    loadData();
  }

  void initBaseCoin(String? value) {
    baseCoin = value ?? 'BTC';
  }

  String get baseCoin => _baseCoin;

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Builder(builder: (context) {
        final value = row.getCells()[0].value as String?;
        return Row(
          children: [
            const Gap(15),
            ImageUtil.exchangeImage(value ?? '', size: 24, isCircle: true),
            const Gap(10),
            Expanded(
              child: Text(
                value ?? '',
                style: Styles.tsBody_14m(context),
              ),
            ),
          ],
        );
      }),
      Builder(builder: (context) {
        final value = row.getCells()[1].value as (num?, num?);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '\$${AppUtil.getLargeFormatString('${value.$1}')}',
              style: Styles.tsBody_14m(context),
            ),
            FittedBox(
              child: Text(
                '≈${AppUtil.getLargeFormatString('${value.$2}')} $baseCoin',
                style: Styles.tsSub_12(context),
              ),
            ),
          ],
        );
      }),
      Builder(builder: (context) {
        final value = row.getCells()[2].value as num?;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${((value ?? 0) * 100).toStringAsFixed(2)}%',
              textAlign: TextAlign.center,
              style: Styles.tsBody_12(context),
            ),
            Container(
              decoration: BoxDecoration(
                color: Styles.cMain.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.hardEdge,
              alignment: Alignment.centerLeft,
              height: 7,
              margin: const EdgeInsets.symmetric(vertical: 3),
              width: double.infinity,
              child: FractionallySizedBox(
                widthFactor: value?.toDouble(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Styles.cMain.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 7,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
          ],
        );
      }),
      Builder(builder: (context) {
        final value = row.getCells()[3].value as num?;
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${((value ?? 0) * 100).toStringAsFixed(2)}%',
            style: TextStyle(
              color: (value ?? 0) > 0
                  ? Styles.cUp(context)
                  : Styles.cDown(context),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }),
      Builder(builder: (context) {
        final value = row.getCells()[4].value as num?;
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${((value ?? 0) * 100).toStringAsFixed(2)}%',
            style: TextStyle(
              color: (value ?? 0) > 0
                  ? Styles.cUp(context)
                  : Styles.cDown(context),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }),
      Builder(builder: (context) {
        final value = row.getCells()[5].value as num?;
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${((value ?? 0) * 100).toStringAsFixed(2)}%',
            style: TextStyle(
              color: (value ?? 0) > 0
                  ? Styles.cUp(context)
                  : Styles.cDown(context),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }),
    ]);
  }

  Future<void> loadData() async {
    final result = await Apis().getExchangeIOList(baseCoin: baseCoin);
    result
        ?.where((element) => element.exchangeName == 'Okex')
        .forEach((e) => e.exchangeName = 'Okx');
    oiList.assignAll(result ?? []);
    buildDataRows();
  }
}
