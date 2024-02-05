import 'package:ank_app/res/styles.dart';
import 'package:flutter/material.dart';

class RateWithSign extends StatelessWidget {
  const RateWithSign(
      {super.key, required this.rate, this.precision = 2, this.fontSize = 12});

  final double? rate;
  final int precision;
  final double fontSize;
  String get rateString {
    final s = '${rate!.toStringAsFixed(precision)}%';
    if (s.startsWith('-')) return s.substring(1);
    return s;
  }

  @override
  Widget build(BuildContext context) {
    if (rate == null) {
      return Text('--%',
          style: TextStyle(
              fontSize: fontSize,
              color: Styles.cUp(context),
              fontWeight: Styles.fontMedium));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(rate! >= 0 ? '+' : '-',
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: Styles.fontMedium,
                color:
                    rate! >= 0 ? Styles.cUp(context) : Styles.cDown(context))),
        Text(
          rateString,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: Styles.fontMedium,
              color: rate! >= 0 ? Styles.cUp(context) : Styles.cDown(context)),
        ),
      ],
    );
  }
}
