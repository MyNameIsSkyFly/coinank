import 'package:ank_app/res/styles.dart';
import 'package:flutter/material.dart';

class RateWithArrow extends StatelessWidget {
  const RateWithArrow({super.key, required this.rate});

  final double rate;
  String get rateString {
    final s = '${(rate * 100).toStringAsFixed(2)}%';
    if (s.startsWith('-')) return s.substring(1);
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          rate >= 0
              ? Icons.arrow_drop_up_rounded
              : Icons.arrow_drop_down_rounded,
          color: rate >= 0 ? Styles.cUp(context) : Styles.cDown(context),
          size: 18,
        ),
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
