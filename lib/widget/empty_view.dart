import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView(
      {super.key, this.size, this.text, this.padding, this.showText = true});

  final double? size;
  final String? text;
  final EdgeInsets? padding;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? Assets.commonIcEmptyBoxDark
                  : Assets.commonIcEmptyBox,
              height: size ?? 100,
              width: size ?? 100),
          if (showText)
            Opacity(
              opacity: 0.3,
              child: Text(
                text ?? S.of(context).s_none_data,
                style: Styles.tsSub_14(context)
                    .copyWith(fontSize: 14 * (size ?? 100) / 100),
              ),
            )
        ],
      ),
    );
  }
}
