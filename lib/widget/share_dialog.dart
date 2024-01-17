import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../res/export.dart';

class ShareDialog extends StatefulWidget {
  const ShareDialog({super.key, required this.image});

  final Uint8List image;

  @override
  State<ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  final _screenshotController = ScreenshotController();

  Future<void> _saveImage() async {
    final image = await _screenshotController.capture();
    if (image == null) return;
    await ImageGallerySaver.saveImage(image);
    AppUtil.showToast(S.current.saved);
    Get.back();
  }

  Future<void> _shareImage() async {
    final image = await _screenshotController.captureAsUiImage(pixelRatio: 2);
    if (image == null) return;
    final filePath = await saveImageToFile(image);
    final result = await Share.shareXFiles([XFile(filePath)]);
    switch ((result.status)) {
      case ShareResultStatus.success:
        AppUtil.showToast(S.current.endOfShare);
        Get.back();
      case ShareResultStatus.dismissed:
        break;
      case ShareResultStatus.unavailable:
        AppUtil.showToast(S.current.unsupported);
    }
  }

  Future<String> saveImageToFile(ui.Image image) async {
    final dic = await getApplicationCacheDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final filePath = '${dic.path}/$fileName';

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData?.buffer.asUint8List();

    if (pngBytes == null) {
      throw Exception('Could not encode image to PNG bytes');
    }

    await File(filePath).writeAsBytes(pngBytes);
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: Get.back,
        child: GestureDetector(
          onTap: () {},
          child: Column(
            children: [
              Gap(MediaQuery.of(context).padding.top + 5),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    child: Screenshot(
                      controller: _screenshotController,
                      child: ColoredBox(
                        color: Theme.of(context).cardColor,
                        child: Column(
                          children: [
                            const Gap(20),
                            Row(
                              children: [
                                const Gap(28),
                                const ImageIcon(
                                    AssetImage(Assets.bottomBarBooks),
                                    size: 15),
                                const Gap(4),
                                Text(
                                  'CoinAnk',
                                  style: Styles.tsBody_12(context).semibold,
                                )
                              ],
                            ),
                            const Gap(7),
                            Expanded(
                              child: Container(
                                  decoration: const BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: Color(0x0C000000),
                                      blurRadius: 11.78,
                                    )
                                  ]),
                                  child: Image.memory(
                                    widget.image,
                                    fit: BoxFit.contain,
                                  )),
                            ),
                            const Gap(14),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              width: double.infinity,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(S.of(context).shareTitle,
                                            style: Styles.tsBody_10(context)
                                                .medium),
                                        const Gap(2),
                                        Text(S.of(context).shareSubTitle,
                                            style: Styles.tsSub_10(context)
                                                .medium),
                                        const Gap(2),
                                        Text(
                                            S.of(context).invitationCodeX(
                                                StoreLogic.to.loginUserInfo
                                                        ?.referralCode ??
                                                    '-'),
                                            style: Styles.tsSub_10(context)
                                                .medium),
                                      ],
                                    ),
                                  ),
                                  Image.asset(Assets.commonQrCode, width: 43),
                                  // Image.asset(Assets.commonQrCode),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ),
              const Gap(15),
              Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewPadding.bottom + 5),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Gap(15),
                        Text(S.of(context).share,
                            style: Styles.tsBody_16(context)),
                        const Spacer(),
                        const CloseButton(),
                      ],
                    ),
                    Row(
                      children: [
                        const Gap(26),
                        Column(
                          children: [
                            IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).dividerTheme.color),
                                padding: const EdgeInsets.all(10),
                                onPressed: _saveImage,
                                icon: Image.asset(
                                  Assets.commonIcShareSave,
                                  width: 25,
                                  height: 25,
                                )),
                            Text(S.of(context).saveImage,
                                style: Styles.tsBody_12(context))
                          ],
                        ),
                        const Gap(40),
                        Column(
                          children: [
                            IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).dividerTheme.color),
                                padding: const EdgeInsets.all(10),
                                onPressed: _shareImage,
                                icon: Image.asset(
                                  Assets.commonIcShareMore,
                                  width: 25,
                                  height: 25,
                                )),
                            Text(S.of(context).more,
                                style: Styles.tsBody_12(context))
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
