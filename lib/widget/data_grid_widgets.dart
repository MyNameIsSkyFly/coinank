import 'package:ank_app/res/styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'animated_color_text.dart';

class DataGridNormalText extends StatelessWidget {
  const DataGridNormalText(
    this.text, {
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: AutoSizeText(
          text,
          maxLines: 1,
          style: Styles.tsBody_16m(context),
          minFontSize: 7,
        ),
      ),
    );
  }
}

class DataGridRateText extends StatelessWidget {
  const DataGridRateText(
    this.text, {
    super.key,
    required this.value,
  });

  final double? value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 80,
        height: 30,
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: value == null || value == 0
              ? Styles.cUp(context)
              : value! > 0
                  ? Styles.cUp(context)
                  : Styles.cDown(context),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class DataGridPriceText extends StatelessWidget {
  const DataGridPriceText(
    this.text, {
    super.key,
    required this.value,
  });

  final String text;
  final double? value;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: AnimatedColorText(
          text: text,
          value: value ?? 0,
          style: TextStyle(fontSize: 16, fontWeight: Styles.fontMedium),
          recyclable: true,
        ),
      ),
    );
  }
}
