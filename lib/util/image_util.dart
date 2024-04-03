import 'dart:math';

import 'package:ank_app/constants/app_const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageUtil {
  ImageUtil._();
  static Widget networkImage(String url,
      {double? width, double? height, Widget? errorWidget}) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fadeInDuration: const Duration(milliseconds: 100),
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
}
