import 'package:ank_app/res/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RateWithArrow extends StatelessWidget {
  const RateWithArrow({
    super.key,
    required this.rate,
    this.fontSize,
    this.precise = 2,
  });

  final double rate;
  final double? fontSize;
  final int precise;

  String get rateString {
    final s = '${rate.toStringAsFixed(precise)}%';
    if (s.startsWith('-')) return s.substring(1);
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          rate >= 0 ? FontAwesomeIcons.caretUp : FontAwesomeIcons.caretDown,
          color: rate >= 0 ? Styles.cUp(context) : Styles.cDown(context),
          size: (fontSize ?? 12) * 0.85,
        ),
        Text(
          rateString,
          style: TextStyle(
              fontSize: fontSize ?? 12,
              fontWeight: Styles.fontMedium,
              color: rate >= 0 ? Styles.cUp(context) : Styles.cDown(context)),
        ),
      ],
    );
  }
}
