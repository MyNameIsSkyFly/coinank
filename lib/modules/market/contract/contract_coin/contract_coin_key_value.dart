import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/animated_color_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContractCoinKeyValue {
  final String key;
  final double? value;
  final NumberFormat? numberFormat;
  final String? baseCoin;

  ContractCoinKeyValue(this.key, this.value,
      {this.numberFormat, this.baseCoin});

  String get convertedValue => handleValue(key, value);

  bool get isRate {
    var tmp = convertedValue.trim();
    return ['+', '-'].any((element) =>
        (tmp.startsWith(element)) && tmp.endsWith('%') ||
        tmp == '0.00%' ||
        tmp == '0.0000%');
  }

  Widget get rateText {
    if (key == 'price') {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: AnimatedColorText(
            text: convertedValue,
            value: value ?? 0,
            style: const TextStyle(fontSize: 16, fontWeight: Styles.fontMedium),
            recyclable: true,
          ),
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
                  color: Colors.white, fontSize: 12),
            ),
          );
        }),
      );
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Builder(builder: (context) {
          return AutoSizeText(
            convertedValue,
            maxLines: 1,
            style: Styles.tsBody_16m(context),
            minFontSize: 7,
          );
        }),
      ),
    );
  }

  String handleValue(String key, double? value) {
    if (value == null && key == 'marketCapChange24H') return '0.00%';
    final tmp = value ?? 0;
    return switch (key) {
      'price' => AppUtil.compressNumberWithLotsOfZeros(value ?? 0),
      'longShortRatio' ||
      'longShortPerson' ||
      'longShortPosition' ||
      'longShortAccount' =>
        Decimal.tryParse('$tmp').toString(),
      'fundingRate' =>
        '${tmp > 0 ? '+' : ''}${(tmp * 100).toStringAsFixed(4)}%',
      'turnover24h' ||
      'openInterest' ||
      'marketCap' ||
      'liquidationH1' ||
      'liquidationH4' ||
      'liquidationH12' ||
      'liquidationH24' =>
        '\$${AppUtil.getLargeFormatString('$tmp', precision: 2)}',
      'priceChangeH1' ||
      'priceChangeH4' ||
      'priceChangeH6' ||
      'priceChangeH12' ||
      'priceChangeH24' =>
        '${tmp > 0 ? '+' : ''}${tmp.toStringAsFixed(2)}%',
      'openInterestChM5' ||
      'openInterestChM15' ||
      'openInterestChM30' ||
      'openInterestCh1' ||
      'openInterestCh4' ||
      'openInterestCh24' ||
      'openInterestCh2D' ||
      'openInterestCh3D' ||
      'openInterestCh7D' ||
      'lsPersonChg5m' ||
      'lsPersonChg15m' ||
      'lsPersonChg30m' ||
      'lsPersonChg1h' ||
      'lsPersonChg4h' ||
      'marketCapChange24H' =>
        '${tmp > 0 ? '+' : ''}${(tmp * 100).toStringAsFixed(2)}%',
      'circulatingSupply' ||
      'totalSupply' ||
      'maxSupply' =>
        numberFormat?.format(tmp) ?? '',
      _ => '0',
    };
  }

  @override
  String toString() {
    return key == 'fundingRate'
        ? '  +0.0000%'
        : isRate
            ? '  +200.00%  '
            : '  ${handleValue(key, value)}  ';
  }
}
