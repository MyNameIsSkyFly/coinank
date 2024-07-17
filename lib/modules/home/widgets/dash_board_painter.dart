import 'dart:math';

import 'package:flutter/material.dart';

class DashBoardPainter extends CustomPainter {
  final double radians;
  final bool isDarkMode;
  final Color upColor;
  final Color downColor;

  DashBoardPainter(this.upColor, this.downColor,
      {super.repaint, required this.radians, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final colorDeep =
        isDarkMode ? const Color(0xffA1A7BB) : const Color(0xff616e85);
    final colorLight =
        isDarkMode ? const Color(0xff252733) : const Color(0xffEFF2F5);
    final pointerColor = isDarkMode ? Colors.white : Colors.black;
    final strokeWidth = min(size.height, size.width) * 0.15;
    final circlePointRadius = strokeWidth / 2.6;
    final unit = min(size.height, size.width) * 0.05;
    final radius = min(size.height, size.width) -
        strokeWidth -
        unit -
        circlePointRadius / 2;
    final upPaint = Paint()
      ..color = upColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final downPaint = Paint()
      ..color = downColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final linePaint = Paint()..color = Colors.red;
    canvas
      ..save()
      ..translate(size.width / 2, size.height - circlePointRadius / 2)
      ..drawArc(
          Rect.fromCenter(
              center: Offset.zero, width: radius * 2, height: radius * 2),
          -pi,
          pi / 2,
          false,
          downPaint)
      ..drawArc(
          Rect.fromCenter(
              center: Offset.zero, width: radius * 2, height: radius * 2),
          -pi / 2,
          pi / 2,
          false,
          upPaint)
      ..restore()
      ..save()
      ..translate(size.width / 2, size.height - circlePointRadius / 2);

    const y = 0.0;
    var x1 = 0.0;
    var x2 = 0.0;
    final pointPaint = Paint()..color = pointerColor;
    linePaint.shader = null;
    canvas.rotate(pi);
    for (var i = 0; i < 60; i++) {
      x1 = radius + strokeWidth;
      x2 = radius + unit + strokeWidth;
      linePaint
        ..strokeWidth = 0.25 * unit
        ..color = (i % 10 == 0 && i != 0) ? colorDeep : colorLight;
      canvas
        ..drawLine(Offset(x1, y), Offset(x2, y), linePaint)
        ..rotate(2 * pi / 120);
    }
    canvas
      ..restore()
      ..drawCircle(Offset(size.width / 2, size.height - circlePointRadius / 2),
          circlePointRadius, pointPaint)
      ..save()
      ..translate(size.width / 2, size.height - circlePointRadius / 2);
    // var radians = (rate - 1) * pi / 2;
    var resultRadians = radians * pi;
    if (resultRadians > pi / 2) {
      resultRadians = pi / 2;
    } else if (resultRadians < -pi / 2) {
      resultRadians = -pi / 2;
    }
    canvas.rotate(resultRadians);
    final path = Path()
      ..moveTo(-unit * 0.4, 0)
      ..lineTo(-unit * 0.12, -radius + unit * 4)
      ..lineTo(unit * 0.12, -radius + unit * 4)
      ..lineTo(unit * 0.4, 0)
      ..close();
    canvas
      ..drawPath(path, pointPaint)
      ..restore();
  }

  @override
  bool shouldRepaint(DashBoardPainter oldDelegate) =>
      radians != oldDelegate.radians;
}
