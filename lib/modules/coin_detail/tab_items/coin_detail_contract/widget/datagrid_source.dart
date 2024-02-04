// ignore: depend_on_referenced_packages
import 'package:ank_app/entity/contract_market_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/rate_with_sign.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Set product's data collection to data grid source.
class ProductDataGridSource extends DataGridSource {
  /// Creates the product data source class with required details.
  ProductDataGridSource(this.items, this.baseCoin) {
    buildDataGridRows();
  }

  /// Instance of products.
  final List<ContractMarketEntity> items;
  final String baseCoin;

  /// Instance of DataGridRow.
  List<DataGridRow> dataGridRows = <DataGridRow>[];

  /// Build DataGridRows
  void buildDataGridRows() {
    dataGridRows = items.map<DataGridRow>((ContractMarketEntity entity) {
      return DataGridRow(cells: <DataGridCell<dynamic>>[
        //todo intl
        DataGridCell<String>(columnName: '交易所', value: entity.exchangeName),
        DataGridCell<(String?, String?, String?)>(
            columnName: '货币',
            value: (entity.symbol, entity.exchangeName, entity.contractType)),
        DataGridCell<double>(columnName: '价格', value: entity.lastPrice),
        DataGridCell<double>(
            columnName: '24H变化%', value: entity.priceChange24h),
        DataGridCell<String>(
            columnName: '24H成交额',
            value: AppUtil.getLargeFormatString('${entity.turnover24h ?? 0}',
                precision: 2)),
        DataGridCell<String>(
            columnName: '持仓',
            value: AppUtil.getLargeFormatString('${entity.oiUSD ?? 0}',
                precision: 2)),
        DataGridCell<double>(columnName: '24H(%)', value: entity.oiChg24h),
        DataGridCell<double>(columnName: '资金费率', value: entity.fundingRate),
      ]);
    }).toList();
  }

  final clickableExchangeNames = [
    'BINANCE',
    'HUOBI',
    'OKX',
    'BYBIT',
    'GATE',
    'BITGET'
  ];

  bool isClickable(String? name) {
    return clickableExchangeNames.contains((name ?? '').toUpperCase());
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ImageUtil.exchangeImage(row.getCells()[0].value.toString(),
                size: 24),
            const Gap(10),
            Expanded(
              child: Text(
                row.getCells()[0].value.toString(),
                overflow: TextOverflow.ellipsis,
                style: Styles.tsBody_14m(Get.context!),
              ),
            ),
          ],
        ),
      ),
      Builder(builder: (context) {
        final item = row.getCells()[1].value as (String?, String?, String?);
        var clickable = isClickable(item.$2);
        return GestureDetector(
          onTap: () {
            if (!clickable) return;
            AppUtil.toKLine(
                item.$2 ?? '', item.$1 ?? '', baseCoin, item.$3 ?? '');
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.$1.toString(),
                overflow: TextOverflow.ellipsis,
                style:
                    clickable ? Styles.tsMain_14m : Styles.tsBody_14m(context),
              ),
            ),
          ),
        );
      }),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
          style: Styles.tsBody_14m(Get.context!),
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: RateWithSign(rate: row.getCells()[3].value ?? 0, fontSize: 14),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: Text(
          row.getCells()[4].value.toString(),
          overflow: TextOverflow.ellipsis,
          style: Styles.tsBody_14m(Get.context!),
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: Text(
          row.getCells()[5].value.toString(),
          overflow: TextOverflow.ellipsis,
          style: Styles.tsBody_14m(Get.context!),
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: RateWithSign(rate: row.getCells()[6].value ?? 0, fontSize: 14),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: Text(
          '${((row.getCells()[7].value ?? 0) * 100).toStringAsFixed(4)}%',
          overflow: TextOverflow.ellipsis,
          style: Styles.tsBody_14m(Get.context!),
        ),
      ),
    ]);
  }

  /// Update DataSource
  void updateDataSource() {
    notifyListeners();
  }

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    return super.compare(a, b, sortColumn);
  }
}
