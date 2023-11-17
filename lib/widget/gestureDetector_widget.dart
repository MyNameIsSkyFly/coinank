import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GestureDetectorWidget extends StatelessWidget {
  const GestureDetectorWidget({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Get.focusScope?.unfocus(),
      onPanDown: (_) => Get.focusScope?.unfocus(),
      child: child,
    );
  }
}
