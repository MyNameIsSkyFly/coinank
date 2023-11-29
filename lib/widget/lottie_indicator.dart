import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieIndicator extends StatelessWidget {
  final double? size;
  final double? height;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? margin;

  const LottieIndicator(
      {super.key, this.height, this.size, this.alignment, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? 80,
      alignment: alignment ?? Alignment.topCenter,
      margin: margin ?? EdgeInsets.only(top: AppConst.height * 0.3),
      child: Lottie.asset(
        StoreLogic.to.isDarkMode == true
            ? 'assets/lottie/loading_dark.json'
            : 'assets/lottie/loading_light.json',
        width: size ?? 80,
        height: size ?? 80,
        repeat: true,
        animate: true,
      ),
    );
  }
}
