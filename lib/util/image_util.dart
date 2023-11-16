import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageUtil {
  static Widget networkImage(String url, {double? width, double? height}) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fadeInDuration: const Duration(milliseconds: 100),
      errorWidget: (context, url, error) => const Icon(Icons.hourglass_empty),
    );
  }
}
