import 'dart:math';

import 'package:ank_app/constants/app_const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageUtil {
  ImageUtil._();

  static Widget networkImage(
    String url, {
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    Widget? errorWidget,
    Duration? fadeInDuration,
    ValueChanged<Object>? errorListener,
    bool progressUseErrorWidget = false,
  }) {
    return CachedNetworkImage(
      key: key,
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 100),
      errorListener: errorListener,
      progressIndicatorBuilder: progressUseErrorWidget
          ? (context, url, progress) {
              return errorWidget ??
                  Icon(
                    Icons.hourglass_empty,
                    size: min(width ?? 0, height ?? 0),
                    color: Colors.grey,
                  );
            }
          : null,
      errorWidget: (context, url, error) {
        return errorWidget ??
            Icon(
              Icons.hourglass_empty,
              size: min(width ?? 0, height ?? 0),
              color: Colors.grey,
            );
      },
    );
  }

  static Widget coinImage(String coinName,
      {double? size, Widget? errorWidget}) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: AppConst.imageHost(coinName),
        width: size,
        height: size,
        fadeInDuration: const Duration(milliseconds: 100),
        errorWidget: (context, url, error) {
          return errorWidget ??
              Icon(
                Icons.hourglass_empty,
                size: size,
                color: Colors.grey,
              );
        },
      ),
    );
  }

  static Widget exchangeImage(String exchangeName,
      {double? size, Widget? errorWidget, bool isCircle = false}) {
    late Widget child;

    child = CachedNetworkImage(
      imageUrl: 'https://cdn01.coinank.com/image/exchange/64/$exchangeName.png',
      width: size,
      height: size,
      fadeInDuration: const Duration(milliseconds: 100),
      errorWidget: (context, url, error) {
        return errorWidget ??
            Icon(
              Icons.hourglass_empty,
              size: size,
              color: Colors.grey,
            );
      },
    );
    if (isCircle) {
      child = ClipOval(child: child);
    }
    return child;
  }

  static Widget newsLogo(String sourceName,
      {double? size, Widget? errorWidget, bool isCircle = false}) {
    late Widget child;

    child = CachedNetworkImage(
      imageUrl: 'https://cdn01.coinank.com/image/news/$sourceName.png',
      width: size,
      fit: BoxFit.cover,
      height: size,
      fadeInDuration: const Duration(milliseconds: 100),
      errorWidget: (context, url, error) {
        return errorWidget ??
            Icon(
              Icons.hourglass_empty,
              size: size,
              color: Colors.grey,
            );
      },
    );
    if (isCircle) {
      child = ClipOval(child: child);
    }
    return child;
  }
}
