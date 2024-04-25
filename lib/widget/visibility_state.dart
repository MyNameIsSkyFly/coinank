import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

abstract class VisibilityState<T extends StatefulWidget> extends State<T> {
  final _key = GlobalKey();
  var notVisibleForAWhile = false;
  var visible = true;
  Timer? _countDownTimer;

  void startCountDownTimer() {
    _countDownTimer = Timer(const Duration(seconds: 7), () {
      notVisibleForAWhile = true;
    });
  }

  void stopCountDownTimer() {
    notVisibleForAWhile = false;
    _countDownTimer?.cancel();
    _countDownTimer = null;
  }

  Widget builder(BuildContext context);

  void onVisibleAgain();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (info) {
        visible = info.visibleFraction == 1;
        if (!visible) {
          startCountDownTimer();
        } else {
          if (notVisibleForAWhile) onVisibleAgain();
          stopCountDownTimer();
        }
      },
      child: builder(context),
    );
  }
}
