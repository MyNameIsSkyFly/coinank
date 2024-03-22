import 'package:ank_app/generated/assets.dart';
import 'package:ank_app/res/styles.dart';
import 'package:flutter/material.dart';

class CategoryTypeSelector extends StatelessWidget {
  const CategoryTypeSelector({
    super.key,
    this.onTapLeft,
    this.onTapRight,
    this.leftSelected = true,
  });

  final VoidCallback? onTapLeft;
  final VoidCallback? onTapRight;
  final bool leftSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 36,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Styles.cLine(context)))),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5)
              .copyWith(left: 0),
          decoration: BoxDecoration(
              color: Theme.of(context).inputDecorationTheme.fillColor,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              GestureDetector(
                onTap: onTapLeft,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.format_list_bulleted_rounded,
                    size: 20,
                    color: leftSelected
                        ? Styles.cBody(context)
                        : Styles.cSub(context),
                  ),
                ),
              ),
              const SizedBox(height: 10, child: VerticalDivider(thickness: 2)),
              GestureDetector(
                onTap: onTapRight,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ImageIcon(const AssetImage(Assets.commonIcBlocks),
                      size: 20,
                      color: !leftSelected
                          ? Styles.cBody(context)
                          : Styles.cSub(context)),
                ),
              ),
            ],
          ),
        ));
  }
}
