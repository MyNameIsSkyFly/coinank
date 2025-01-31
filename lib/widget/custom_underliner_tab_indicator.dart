import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';

class CustomUnderlineTabIndicator extends Decoration {
  final BorderSide borderSide;
  final EdgeInsetsGeometry insets;
  final StrokeCap strokeCap; // 控制器的边角形状
  final double width; // 控制器的宽度

  const CustomUnderlineTabIndicator({
    this.borderSide = const BorderSide(width: 4, color: Styles.cMain),
    this.insets = EdgeInsets.zero,
    this.strokeCap = StrokeCap.round,
    this.width = 32,
  });

  const CustomUnderlineTabIndicator.thin({
    this.borderSide = const BorderSide(width: 2, color: Styles.cMain),
    this.insets = EdgeInsets.zero,
    this.strokeCap = StrokeCap.round,
    this.width = 32,
  });

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is CustomUnderlineTabIndicator) {
      return CustomUnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t) ??
            EdgeInsetsGeometry.infinity,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is CustomUnderlineTabIndicator) {
      return CustomUnderlineTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t) ??
            EdgeInsetsGeometry.infinity,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(this, onChanged);
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final indicator = insets.resolve(textDirection).deflateRect(rect);

    // 希望的宽度
    final wantWidth = width;
    // 取中间坐标
    final cw = (indicator.left + indicator.right) / 2;
    // 这里是核心代码
    return Rect.fromLTWH(cw - wantWidth / 2,
        indicator.bottom - borderSide.width, wantWidth, borderSide.width);
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  final CustomUnderlineTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final rect = offset & configuration.size!;
    final textDirection = configuration.textDirection!;
    final indicator = decoration
        ._indicatorRectFor(rect, textDirection)
        .deflate(decoration.borderSide.width / 2);
    final paint = decoration.borderSide.toPaint()
      ..strokeCap = decoration.strokeCap; // 这里修改控制器边角的形状
    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
  }
}
