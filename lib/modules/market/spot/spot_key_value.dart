import 'package:ank_app/res/styles.dart';
import 'package:ank_app/util/app_util.dart';
import 'package:ank_app/widget/animated_color_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
    if (key == 'price') {
      return Center(
        child: AnimatedColorText(
          text: convertedValue,
          value: value ?? 0,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          recyclable: true,
        ),
      );
    }
    if (isRate) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Builder(builder: (context) {
          return Container(
            width: 80,
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.symmetric(vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: value == null || value == 0
                  ? Styles.cUp(context)
                  : value! > 0
                      ? Styles.cUp(context)
                      : Styles.cDown(context),
            ),
            child: Text(
              convertedValue,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
          );
        }),
      );
    }
    return Center(
      child: Builder(builder: (context) {
        return AutoSizeText(
          convertedValue,
          maxLines: 1,
          style:
              Styles.tsBody_16m(context).copyWith(fontWeight: FontWeight.w700),
        );
      }),
    );
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
    return isRate ? '  +200.00%  ' : '  ${handleValue(key ?? ' ', value)}  ';
  }
}
