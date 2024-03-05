import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../res/styles.dart';

class AnimatedColorText extends StatefulWidget {
  const AnimatedColorText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    required this.value,
    this.recyclable = false,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final double value;
  final bool recyclable;

  @override
  State<AnimatedColorText> createState() => _AnimatedColorTextState();
}

class _AnimatedColorTextState extends State<AnimatedColorText> {
  Color? _color;
  var _duration = const Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      style: (widget.style ?? const TextStyle(fontSize: 14))
          .copyWith(color: _color ?? Styles.cBody(context)),
      duration: _duration,
      child: AutoSizeText(
        widget.text,
        textAlign: widget.textAlign,
        minFontSize: 8,
        maxLines: 1,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedColorText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.recyclable &&
        ((widget.value - oldWidget.value) / oldWidget.value).abs() > 0.5) {
      return;
    }
    if (widget.value > oldWidget.value) {
      _color = Styles.cUp(context);
    } else if (widget.value < oldWidget.value) {
      _color = Styles.cDown(context);
    } else {
      _color = Styles.cBody(context);
    }
    updateColor();
  }

  void updateColor() {
    if (mounted) {
      setState(() => _duration = Duration.zero);
    }
    Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _color = Styles.cBody(context);
          _duration = const Duration(seconds: 1);
        });
      }
    });
  }
}
