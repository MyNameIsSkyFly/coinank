import 'package:flutter/material.dart';

class TrapeziumPainter extends CustomPainter {
  final double width;
  final Color color;

  TrapeziumPainter({super.repaint, required this.width, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(width, 0);
    path.lineTo(0, size.height);
    path.lineTo(-width, size.height);
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(TrapeziumPainter oldDelegate) => false;
}
