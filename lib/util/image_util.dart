import 'dart:math';

import 'package:ank_app/constants/app_const.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/util/http_adapter/_http_adapter_api.dart'
    if (dart.library.io) 'package:ank_app/util/http_adapter/_http_adapter_io.dart'
    if (dart.library.html) 'package:ank_app/util/http_adapter/_http_adapter_html.dart'
    as native_adapter;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager_dio/flutter_cache_manager_dio.dart';

class ImageUtil {
  ImageUtil._();

  static void init() {
    final dio = Dio()..httpClientAdapter = native_adapter.getNativeAdapter();
    DioCacheManager.initialize(dio);
  }

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
      cacheManager: DioCacheManager.instance,
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
        cacheManager: DioCacheManager.instance,
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
      cacheManager: DioCacheManager.instance,
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
      cacheManager: DioCacheManager.instance,
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
