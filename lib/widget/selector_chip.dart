import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';

class SelectorChip extends StatelessWidget {
  const SelectorChip({
    super.key,
    required this.onTap,
    required this.text,
  });

  final VoidCallback onTap;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          height: 30,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerTheme.color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Text(text ?? '', style: Styles.tsSub_12m(context)),
              const Gap(10),
              const Icon(Icons.keyboard_arrow_down, size: 14)
            ],
          )),
    );
  }
}
