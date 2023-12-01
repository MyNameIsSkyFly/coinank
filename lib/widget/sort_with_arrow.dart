import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';

enum SortStatus {
  normal,
  down,
  up,
}

class SortWithArrow extends StatelessWidget {
  const SortWithArrow({
    super.key,
    this.icon,
    required this.title,
    this.status = SortStatus.normal,
    this.onTap,
    this.style,
  });

  final Widget? icon;
  final String title;
  final SortStatus status;
  final TextStyle? style;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          Text(
            title,
            style: style ?? Styles.tsSub_12(context),
          ),
          const SizedBox(width: 2),
          if (status == SortStatus.normal)
            Image.asset(
              Assets.commonIconSortN,
              width: 9,
              height: 12,
            ),
          if (status == SortStatus.up)
            Image.asset(
              Assets.commonIconSortUp,
              width: 9,
              height: 12,
            ),
          if (status == SortStatus.down)
            Image.asset(
              Assets.commonIconSortDown,
              width: 9,
              height: 12,
            ),
        ],
      ),
    );
  }
}
