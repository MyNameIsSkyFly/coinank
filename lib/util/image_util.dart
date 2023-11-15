import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageUtil {
  static Widget networkImage(String url, {double? width, double? height}) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      errorWidget: (context, url, error) => Icon(Icons.error_outline_rounded),
    );
  }
}
