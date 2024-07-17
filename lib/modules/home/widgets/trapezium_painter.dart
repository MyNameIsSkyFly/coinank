import 'package:flutter/material.dart';

class TrapeziumPainter extends CustomPainter {
  final double width;
  final Color color;

  TrapeziumPainter({super.repaint, required this.width, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(width, 0)
      ..lineTo(0, size.height)
      ..lineTo(-width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(TrapeziumPainter oldDelegate) => false;
}
