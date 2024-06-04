import 'package:flutter/material.dart';

import '../generated/assets.dart';
import '../generated/l10n.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, this.size, this.text, this.padding});

  final double? size;
  final String? text;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        children: [
          Image.asset(Assets.commonIcEmptyBox,
              height: size ?? 100, width: size ?? 100),
          Text(text ?? S.of(context).s_none_data)
        ],
      ),
    );
  }
}
