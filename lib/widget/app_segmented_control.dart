import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';

class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.children,
    required this.onValueChanged,
    this.groupValue,
  });

  final Map<T, Widget> children;
  final T? groupValue;
  final ValueChanged<T?> onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Styles.cTextFieldFill(context),
      ),
      child: Row(
        children: children.entries
            .map((e) => GestureDetector(
                  onTap: () => onValueChanged(e.key),
                  child: Container(
                    decoration: BoxDecoration(
                      color: groupValue == e.key
                          ? Styles.cScaffoldBackground(context)
                          : null,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    child: e.value,
                  ),
                ))
            .toList(),
      ),
    );
  }
}
