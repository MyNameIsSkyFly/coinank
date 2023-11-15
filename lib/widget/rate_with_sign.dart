import 'package:ank_app/res/styles.dart';
import 'package:flutter/material.dart';

class RateWithSign extends StatelessWidget {
  const RateWithSign({super.key, required this.rate, this.precise = 2});

  final double rate;
  final int precise;
  String get rateString {
    final s = '${(rate * 100).toStringAsFixed(precise)}%';
    if (s.startsWith('-')) return s.substring(1);
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(rate >= 0 ? '+' : '-',
            style: TextStyle(
                fontSize: 12,
                fontWeight: Styles.fontMedium,
                color:
                    rate >= 0 ? Styles.cUp(context) : Styles.cDown(context))),
        Text(
          rateString,
          style: TextStyle(
              fontSize: 12,
              fontWeight: Styles.fontMedium,
              color: rate >= 0 ? Styles.cUp(context) : Styles.cDown(context)),
        ),
      ],
    );
  }
}
