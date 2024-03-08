import 'package:ank_app/res/export.dart';
import 'package:flutter/cupertino.dart';

class TripleStateSortButton extends StatelessWidget {
  const TripleStateSortButton(
      {super.key,
      required this.isAsc,
      this.onChanged,
      required this.title,
      this.twoState = false});

  final String title;
  final bool? isAsc;
  final bool twoState;
  final void Function(bool? isAsc)? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (twoState) {
          onChanged?.call(switch (isAsc ?? true) {
            true => false,
            false => true,
          });
        } else {
          onChanged?.call(switch (isAsc) {
            true => false,
            false => null,
            null => true,
          });
        }
      },
      child: Row(
        children: [
          Text(title, style: Styles.tsSub_12(context)),
          const SizedBox(width: 6),
          Transform.scale(
            scaleY: 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.triangle_fill,
                  size: 7,
                  color: isAsc == true ? Styles.cMain : Styles.cSub(context),
                ),
                Transform.rotate(
                    angle: 3.1415926,
                    child: Icon(
                      CupertinoIcons.triangle_fill,
                      size: 7,
                      color:
                          isAsc == false ? Styles.cMain : Styles.cSub(context),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TripleStateSortIcon extends StatelessWidget {
  const TripleStateSortIcon(
      {super.key, required this.isAsc, this.twoState = false});

  final bool? isAsc;
  final bool twoState;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleY: 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.triangle_fill,
            size: 7,
            color: isAsc == true ? Styles.cMain : Styles.cSub(context),
          ),
          Transform.rotate(
              angle: 3.1415926,
              child: Icon(
                CupertinoIcons.triangle_fill,
                size: 7,
                color: isAsc == false ? Styles.cMain : Styles.cSub(context),
              )),
        ],
      ),
    );
  }
}
