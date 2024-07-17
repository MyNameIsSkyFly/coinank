// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math' as math;

import 'package:ank_app/res/export.dart';
import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const double _kDragContainerExtentPercentage = 0.25;

const double _kDragSizeFactorLimit = 1.5;

const double _kFullPercentage = 0.67;

const Duration _kIndicatorSnapDuration = Duration(milliseconds: 150);

const Duration _kIndicatorScaleDuration = Duration(milliseconds: 200);

typedef RefreshCallback = Future<void> Function();

enum _AppRefreshMode {
  drag, // Pointer is down.
  armed, // Dragged far enough that an up event will run the onRefresh callback.
  snap, // Animating to the indicator's final "displacement".
  refresh, // Running the refresh callback.
  done, // Animating the indicator's fade-out after refreshing.
  canceled, // Animating the indicator's fade-out after not arming.
}

class AppRefresh extends StatefulWidget {
  const AppRefresh({
    super.key,
    required this.child,
    this.displacement = 40.0,
    this.edgeOffset = 0.0,
    this.onRefresh,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
  });

  final Widget child;

  final double displacement;

  final double edgeOffset;

  final RefreshCallback? onRefresh;

  final ScrollNotificationPredicate notificationPredicate;

  final String? semanticsLabel;

  final String? semanticsValue;

  @override
  AppRefreshState createState() => AppRefreshState();
}

/// Contains the state for a [AppRefresh]. This class can be used to
/// programmatically show the refresh indicator, see the [show] method.
class AppRefreshState extends State<AppRefresh>
    with TickerProviderStateMixin<AppRefresh> {
  late AnimationController _positionController;
  late AnimationController _scaleController;
  late Animation<double> _positionFactor;
  late Animation<double> _scaleFactor;

  _AppRefreshMode? _mode;
  late Future<void> _pendingRefreshFuture;
  bool? _isIndicatorAtTop;
  double? _dragOffset;

  static final Animatable<double> _kDragSizeFactorLimitTween =
      Tween<double>(begin: 0, end: _kDragSizeFactorLimit);
  static final Animatable<double> _oneToZeroTween =
      Tween<double>(begin: 1, end: 0);

  @override
  void initState() {
    super.initState();
    _positionController = AnimationController(vsync: this);
    _positionFactor = _positionController.drive(_kDragSizeFactorLimitTween);
    _scaleController = AnimationController(vsync: this);
    _scaleFactor = _scaleController.drive(_oneToZeroTween);
  }

  @override
  void dispose() {
    _positionController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  bool _shouldStart(ScrollNotification notification) {
    // If the notification.dragDetails is null, this scroll is not triggered by
    // user dragging. It may be a result of ScrollController.jumpTo or ballistic scroll.
    // In this case, we don't want to trigger the refresh indicator.
    return ((notification is ScrollStartNotification &&
                notification.dragDetails != null) ||
            (notification is ScrollUpdateNotification &&
                notification.dragDetails != null &&
                false)) &&
        ((notification.metrics.axisDirection == AxisDirection.up &&
                notification.metrics.extentAfter == 0.0) ||
            (notification.metrics.axisDirection == AxisDirection.down &&
                notification.metrics.extentBefore == 0.0)) &&
        _mode == null &&
        _start(notification.metrics.axisDirection);
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (!widget.notificationPredicate(notification)) {
      return false;
    }
    if (_shouldStart(notification)) {
      setState(() {
        _mode = _AppRefreshMode.drag;
      });
      return false;
    }
    bool? indicatorAtTopNow;
    switch (notification.metrics.axisDirection) {
      case AxisDirection.down:
      case AxisDirection.up:
        indicatorAtTopNow = true;
      case AxisDirection.left:
      case AxisDirection.right:
        indicatorAtTopNow = null;
    }
    if (indicatorAtTopNow != _isIndicatorAtTop) {
      if (_mode == _AppRefreshMode.drag || _mode == _AppRefreshMode.armed) {
        _dismiss(_AppRefreshMode.canceled);
      }
    } else if (notification is ScrollUpdateNotification) {
      if (_mode == _AppRefreshMode.drag || _mode == _AppRefreshMode.armed) {
        if (notification.metrics.axisDirection == AxisDirection.down) {
          _dragOffset = _dragOffset! - notification.scrollDelta!;
        } else if (notification.metrics.axisDirection == AxisDirection.up) {
          _dragOffset = _dragOffset! + notification.scrollDelta!;
        }
        _checkDragOffset(notification.metrics.viewportDimension);
      }
      if (_mode == _AppRefreshMode.armed && notification.dragDetails == null) {
        // On iOS start the refresh when the Scrollable bounces back from the
        // overscroll (ScrollNotification indicating this don't have dragDetails
        // because the scroll activity is not directly triggered by a drag).
        _show();
      }
    } else if (notification is OverscrollNotification) {
      if (_mode == _AppRefreshMode.drag || _mode == _AppRefreshMode.armed) {
        if (notification.metrics.axisDirection == AxisDirection.down) {
          _dragOffset = _dragOffset! - notification.overscroll;
        } else if (notification.metrics.axisDirection == AxisDirection.up) {
          _dragOffset = _dragOffset! + notification.overscroll;
        }
        _checkDragOffset(notification.metrics.viewportDimension);
      }
    } else if (notification is ScrollEndNotification) {
      switch (_mode) {
        case _AppRefreshMode.armed:
          if (_positionController.value < _kFullPercentage) {
            _dismiss(_AppRefreshMode.canceled);
          } else {
            _show();
          }
        case _AppRefreshMode.drag:
          _dismiss(_AppRefreshMode.canceled);
        case _AppRefreshMode.canceled:
        case _AppRefreshMode.done:
        case _AppRefreshMode.refresh:
        case _AppRefreshMode.snap:
        case null:
          // do nothing
          break;
      }
    }
    return false;
  }

  bool _handleIndicatorNotification(
      OverscrollIndicatorNotification notification) {
    if (notification.depth != 0 || !notification.leading) {
      return false;
    }
    if (_mode == _AppRefreshMode.drag) {
      notification.disallowIndicator();
      return true;
    }
    return false;
  }

  bool _start(AxisDirection direction) {
    assert(_mode == null);
    assert(_isIndicatorAtTop == null);
    assert(_dragOffset == null);
    switch (direction) {
      case AxisDirection.down:
      case AxisDirection.up:
        _isIndicatorAtTop = true;
      case AxisDirection.left:
      case AxisDirection.right:
        _isIndicatorAtTop = null;
        // we do not support horizontal scroll views.
        return false;
    }
    _dragOffset = 0.0;
    _scaleController.value = 0.0;
    _positionController.value = 0.0;
    return true;
  }

  void _checkDragOffset(double containerExtent) {
    assert(_mode == _AppRefreshMode.drag || _mode == _AppRefreshMode.armed);
    var newValue =
        _dragOffset! / (containerExtent * _kDragContainerExtentPercentage);
    if (_mode == _AppRefreshMode.armed) {
      newValue = math.max(newValue, 1.0 / _kDragSizeFactorLimit);
    }
    _positionController.value = clampDouble(newValue, 0, _kFullPercentage);
    if (_mode == _AppRefreshMode.drag &&
        _positionController.value >= _kFullPercentage) {
      _mode = _AppRefreshMode.armed;
    }
  }

  // Stop showing the refresh indicator.
  Future<void> _dismiss(_AppRefreshMode newMode) async {
    await Future<void>.value();
    // This can only be called from _show() when refreshing and
    // _handleScrollNotification in response to a ScrollEndNotification or
    // direction change.
    assert(
        newMode == _AppRefreshMode.canceled || newMode == _AppRefreshMode.done);
    setState(() {
      _mode = newMode;
    });
    switch (_mode!) {
      case _AppRefreshMode.done:
        await _scaleController.animateTo(1, duration: _kIndicatorScaleDuration);
      case _AppRefreshMode.canceled:
        await _positionController.animateTo(0,
            duration: _kIndicatorScaleDuration);
      case _AppRefreshMode.armed:
      case _AppRefreshMode.drag:
      case _AppRefreshMode.refresh:
      case _AppRefreshMode.snap:
        assert(false);
    }
    if (mounted && _mode == newMode) {
      _dragOffset = null;
      _isIndicatorAtTop = null;
      setState(() {
        _mode = null;
      });
    }
  }

  void _show() {
    assert(_mode != _AppRefreshMode.refresh);
    assert(_mode != _AppRefreshMode.snap);
    if (widget.onRefresh == null) return;
    final completer = Completer<void>();
    _pendingRefreshFuture = completer.future;
    _mode = _AppRefreshMode.snap;
    _positionController
        .animateTo(1.0 / _kDragSizeFactorLimit,
            duration: _kIndicatorSnapDuration)
        .then<void>((void value) {
      if (mounted && _mode == _AppRefreshMode.snap) {
        setState(() {
          // Show the indeterminate progress indicator.
          _mode = _AppRefreshMode.refresh;
        });

        widget.onRefresh!().whenComplete(() {
          if (mounted && _mode == _AppRefreshMode.refresh) {
            completer.complete();
            _dismiss(_AppRefreshMode.done);
          }
        });
      }
    });
  }

  Future<void> show({bool atTop = true}) {
    if (_mode != _AppRefreshMode.refresh && _mode != _AppRefreshMode.snap) {
      if (_mode == null) {
        _start(atTop ? AxisDirection.down : AxisDirection.up);
      }
      _show();
    }
    return _pendingRefreshFuture;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final Widget child = NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: _handleIndicatorNotification,
        child: widget.child,
      ),
    );
    assert(() {
      if (_mode == null) {
        assert(_dragOffset == null);
        assert(_isIndicatorAtTop == null);
      } else {
        assert(_dragOffset != null);
        assert(_isIndicatorAtTop != null);
      }
      return true;
    }());
    return Stack(
      children: <Widget>[
        child,
        if (_mode != null)
          Positioned(
            top: _isIndicatorAtTop! ? widget.edgeOffset : null,
            bottom: !_isIndicatorAtTop! ? widget.edgeOffset : null,
            left: 0,
            right: 0,
            child: SizeTransition(
              axisAlignment: _isIndicatorAtTop! ? 1.0 : -1.0,
              sizeFactor: _positionFactor, // this is what brings it down
              child: Container(
                padding: _isIndicatorAtTop!
                    ? EdgeInsets.only(top: widget.displacement)
                    : EdgeInsets.only(bottom: widget.displacement),
                alignment: _isIndicatorAtTop!
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
                child: ScaleTransition(
                  scale: _scaleFactor,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Styles.cLine(context),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Lottie.asset(
                        StoreLogic.to.isDarkMode == true
                            ? 'assets/lottie/loading_dark.json'
                            : 'assets/lottie/loading_light.json',
                        controller: _mode == _AppRefreshMode.refresh ||
                                _mode == _AppRefreshMode.done
                            ? null
                            : _positionController,
                        repeat: _mode == _AppRefreshMode.refresh ||
                            _mode == _AppRefreshMode.done,
                        width: 30,
                        height: 30),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
