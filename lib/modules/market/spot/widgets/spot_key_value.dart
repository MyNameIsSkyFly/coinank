import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/data_grid_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpotKeyValue {
  final String key;
  final double? value;
  final NumberFormat? numberFormat;
  final String? baseCoin;

  SpotKeyValue(this.key, this.value, {this.numberFormat, this.baseCoin});

  String get convertedValue => handleValue(key, value);

  bool get isRate {
    var tmp = convertedValue;
    return ['+', '-'].any((element) =>
        (tmp.startsWith(element)) && tmp.endsWith('%') ||
        tmp == '0.00%' ||
        tmp == '0.0000%');
  }

  Widget get rateText {
    if (key == 'price') return DataGridPriceText(convertedValue, value: value);
    if (isRate) return DataGridRateText(convertedValue, value: value);
    return DataGridNormalText(convertedValue);
  }

  String handleValue(String key, double? value) {
    final tmp = value ?? 0;
    return switch (key) {
      'price' => AppUtil.compressNumberWithLotsOfZeros(value ?? 0),
      'turnover24h' ||
      'marketCap' =>
        '\$${AppUtil.getLargeFormatString('$tmp', precision: 2)}',
      'priceChangeH24' ||
      'priceChangeH12' ||
      'priceChangeH8' ||
      'priceChangeH4' ||
      'priceChangeH1' ||
      'priceChangeM5' ||
      'priceChangeM15' ||
      'priceChangeM30' =>
        '${tmp > 0 ? '+' : ''}${tmp.toStringAsFixed(2)}%',
      'circulatingSupply' ||
      'totalSupply' ||
      'maxSupply' =>
        numberFormat?.format(tmp) ?? '',
      'turnoverChg24h' =>
        '${(value ?? 0) > 0 ? '+' : ''}${((value ?? 0) * 100).toStringAsFixed(2)}%',
      _ => '0',
    };
  }

  @override
  String toString() {
    return isRate ? '  +200.00%  ' : '  ${handleValue(key, value)}  ';
  }
}
